import 'package:flutter/material.dart';
import 'package:meosemptyflutter/widgets/hotel/hotel_overview_section.dart';
import 'package:meosemptyflutter/widgets/hotel/hotel_amenities_section.dart';
import 'package:meosemptyflutter/widgets/hotel/hotel_rooms_section.dart';
import 'package:intl/intl.dart'; // Add this import

class HotelScreen extends StatefulWidget {
  final String hotelName;
  final Color color;
  final int index;

  const HotelScreen({
    super.key,
    required this.hotelName,
    required this.color,
    required this.index,
  });

  @override
  State<HotelScreen> createState() => _HotelScreenState();
}

class _HotelScreenState extends State<HotelScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  
  // Keys to identify sections for scrolling
  final GlobalKey _overviewKey = GlobalKey();
  final GlobalKey _amenitiesKey = GlobalKey();
  final GlobalKey _roomsKey = GlobalKey();
  
  int _currentTabIndex = 0;
  bool _isScrolling = false;
  bool _showDetailedAppBar = false;
  
  // Mock data for reservation details
  late DateTime _checkInDate;
  late DateTime _checkOutDate;
  int _guestCount = 2;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Listen to scroll position to update active tab
    _scrollController.addListener(_updateTabOnScroll);
    
    // Listen to tab changes
    _tabController.addListener(_handleTabChange);
    
    // Initialize dates
    _checkInDate = DateTime.now().add(const Duration(days: 7));
    _checkOutDate = DateTime.now().add(const Duration(days: 10));
    
    // Add listener for app bar transformation
    _scrollController.addListener(_handleScrollForAppBar);
  }
  
  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _scrollController.removeListener(_updateTabOnScroll);
    _scrollController.removeListener(_handleScrollForAppBar);
    _scrollController.dispose();
    super.dispose();
  }
  
  // Update app bar based on scroll position
  void _handleScrollForAppBar() {
    // Show detailed app bar when scroll offset is greater than 100
    if (_scrollController.hasClients) {
      bool showDetail = _scrollController.offset > 100;
      if (showDetail != _showDetailedAppBar) {
        setState(() {
          _showDetailedAppBar = showDetail;
        });
      }
    }
  }
  
  // Handle tab controller changes
  void _handleTabChange() {
    if (_tabController.indexIsChanging || _tabController.index != _currentTabIndex) {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
      
      if (!_isScrolling) {
        _scrollToCurrentSection();
      }
    }
  }
  
  void _scrollToCurrentSection() {
    switch (_currentTabIndex) {
      case 0:
        _scrollToSection(_overviewKey);
        break;
      case 1:
        _scrollToSection(_amenitiesKey);
        break;
      case 2:
        _scrollToSection(_roomsKey);
        break;
    }
  }
  
  // Updates the tab based on scroll position
  void _updateTabOnScroll() {
    if (!_scrollController.hasClients) return;
    
    _isScrolling = true;
    
    // Using a debounced approach to prevent excessive tab updates
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;
      
      final overviewContext = _overviewKey.currentContext;
      final amenitiesContext = _amenitiesKey.currentContext;
      final roomsContext = _roomsKey.currentContext;
      
      if (overviewContext == null || amenitiesContext == null || roomsContext == null) {
        _isScrolling = false;
        return;
      }
      
      final RenderBox overviewBox = overviewContext.findRenderObject() as RenderBox;
      final RenderBox amenitiesBox = amenitiesContext.findRenderObject() as RenderBox;
      final RenderBox roomsBox = roomsContext.findRenderObject() as RenderBox;
      
      final overviewPos = overviewBox.localToGlobal(Offset.zero).dy;
      final amenitiesPos = amenitiesBox.localToGlobal(Offset.zero).dy;
      final roomsPos = roomsBox.localToGlobal(Offset.zero).dy;
      
      // The offset to account for the app bar and tabs height
      final offsetHeight = 150.0;
      
      int newIndex;
      
      if (roomsPos < offsetHeight) {
        newIndex = 2; // Rooms section
      } else if (amenitiesPos < offsetHeight) {
        newIndex = 1; // Amenities section
      } else {
        newIndex = 0; // Overview section
      }
      
      if (newIndex != _currentTabIndex) {
        setState(() {
          _currentTabIndex = newIndex;
          _tabController.animateTo(newIndex, duration: Duration.zero);
        });
      }
      
      _isScrolling = false;
    });
  }
  
  // Scroll to a specific section
  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      _isScrolling = true;
      
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.0,
      ).then((_) {
        // Add a small delay to prevent immediate scroll detection
        Future.delayed(const Duration(milliseconds: 500), () {
          _isScrolling = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('MMM dd');
    final formattedCheckIn = dateFormatter.format(_checkInDate);
    final formattedCheckOut = dateFormatter.format(_checkOutDate);
    
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          // Mark as scrolling during user scroll interactions
          if (notification is ScrollStartNotification) {
            _isScrolling = true;
          } else if (notification is ScrollEndNotification) {
            // Add delay before setting isScrolling to false to allow position to settle
            Future.delayed(const Duration(milliseconds: 200), () {
              _isScrolling = false;
              _updateTabOnScroll();
            });
          }
          return false;
        },
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 250.0,
                floating: false,
                pinned: true,
                backgroundColor: widget.color,
                title: AnimatedOpacity(
                  opacity: _showDetailedAppBar ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: _showDetailedAppBar ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.hotelName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            "$formattedCheckIn - $formattedCheckOut • $_guestCount guests",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ) : null,
                ),
                flexibleSpace: FlexibleSpaceBar(
                  title: _showDetailedAppBar 
                      ? null 
                      : Text(widget.hotelName),
                  background: Stack(
                    children: [
                      Container(
                        color: widget.color,
                        child: Center(
                          child: Icon(
                            Icons.hotel,
                            size: 100,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(48),
                  child: Container(
                    color: Colors.white,
                    child: TabBar(
                      controller: _tabController,
                      labelColor: widget.color,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: widget.color,
                      tabs: const [
                        Tab(text: 'Overview'),
                        Tab(text: 'Amenities'),
                        Tab(text: 'Rooms'),
                      ],
                      onTap: (index) {
                        if (index == _currentTabIndex) {
                          // If tapping the current tab, scroll to the top of that section
                          _scrollToCurrentSection();
                        }
                        // The TabController listener will handle other tab changes
                      },
                    ),
                  ),
                ),
              ),
            ];
          },
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Overview Section
                  HotelOverviewSection(
                    hotelName: widget.hotelName,
                    index: widget.index,
                    sectionKey: _overviewKey,
                  ),
                  
                  const Divider(height: 24),
                  
                  // Amenities Section
                  HotelAmenitiesSection(
                    color: widget.color,
                    sectionKey: _amenitiesKey,
                  ),
                  
                  const Divider(height: 24),
                  
                  // Rooms Section
                  HotelRoomsSection(
                    color: widget.color,
                    sectionKey: _roomsKey,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
