import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'room_selection_screen.dart';

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
  final GlobalKey _policyKey = GlobalKey();
  final GlobalKey _locationKey = GlobalKey();

  int _currentTabIndex = 0;
  bool _isScrolling = false;
  bool _showDetailedAppBar = false;
  bool _showBottomBar = true;
  bool _hasVisitedRoomsSection = false; // New flag to track if user has visited rooms section

  // Mock data for reservation details
  late DateTime _checkInDate;
  late DateTime _checkOutDate;
  final int _guestCount = 2;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);

    // Initialize dates
    _checkInDate = DateTime.now().add(const Duration(days: 7));
    _checkOutDate = DateTime.now().add(const Duration(days: 10));

    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Combined scroll handler for both app bar and bottom bar
  void _handleScroll() {
    // App bar handling
    if (_scrollController.hasClients) {
      bool showDetail = _scrollController.offset > 100;
      if (showDetail != _showDetailedAppBar) {
        setState(() {
          _showDetailedAppBar = showDetail;
        });
      }

      // Bottom bar handling
      // Get the position of the rooms section
      double? roomsPosition = _getPositionFromKey(_roomsKey);
      if (roomsPosition != null) {
        final scrollPosition = _scrollController.offset;

        // Show bottom bar when at the top or hide it when rooms section is visible
        // or user has visited rooms section but not at the top
        setState(() {
          if (scrollPosition < 818) {
            // Show when user is at the top of the page
            _showBottomBar = true;
          } else if (scrollPosition > 1620) {
            // Hide if user has visited rooms section and not at top
            _showBottomBar = false;
          } else {
            _showBottomBar = false;
          }
        });
      }
    }
  }

  // Scroll to the rooms section
  void _scrollToRooms() {
    if (_roomsKey.currentContext != null) {
      final roomsPosition = _getPositionFromKey(_roomsKey);
      if (roomsPosition != null) {
        setState(() {
          _isScrolling = true;
        });

        _scrollController
            .animateTo(
          roomsPosition - 100, // Offset to account for app bar
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        )
            .then((_) {
          if (mounted) {
            setState(() {
              _isScrolling = false;
              _currentTabIndex = 2; // Update to Rooms tab
              _tabController.animateTo(2);
              _showBottomBar = false; // Hide bottom bar after scrolling
            });
          }
        });
      }
    }
  }

  void _updateTabOnScroll() {
    if (!_scrollController.hasClients || _isScrolling) return;

    final scrollPosition = _scrollController.offset;
    final viewportHeight = _scrollController.position.viewportDimension;

    // Get the positions of all sections
    final positions = [
      _getPositionFromKey(_overviewKey),
      _getPositionFromKey(_amenitiesKey),
      _getPositionFromKey(_roomsKey),
      _getPositionFromKey(_policyKey),
      _getPositionFromKey(_locationKey),
    ];

    // Find the section that is most visible in the viewport
    int visibleSectionIndex = 0;

    for (int i = 0; i < positions.length; i++) {
      if (positions[i] != null) {
        final position = positions[i]!;
        if (position <= scrollPosition + viewportHeight / 2 &&
            ((positions[visibleSectionIndex] == null) ||
                position > positions[visibleSectionIndex]! ||
                visibleSectionIndex == 0)) {
          visibleSectionIndex = i;
        }
      }
    }

    // Update tab if needed
    if (visibleSectionIndex != _currentTabIndex) {
      setState(() {
        _currentTabIndex = visibleSectionIndex;
        _tabController.animateTo(visibleSectionIndex, duration: Duration.zero);
      });
    }
  }

  // Helper method to get scroll position from a key
  double? _getPositionFromKey(GlobalKey key) {
    final context = key.currentContext;
    if (context == null) return null;

    final RenderBox box = context.findRenderObject() as RenderBox;
    final position = box.localToGlobal(Offset.zero).dy;
    return position;
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('MMM dd');
    final formattedCheckIn = dateFormatter.format(_checkInDate);
    final formattedCheckOut = dateFormatter.format(_checkOutDate);

    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          // Only process scroll notifications when not programmatically scrolling
          if (_isScrolling) return false;

          if (notification is ScrollStartNotification) {
            _isScrolling = false; // Don't set to true here to allow tab updates during user scrolling
          } else if (notification is ScrollEndNotification) {
            Future.delayed(const Duration(milliseconds: 200), () {
              if (mounted) _updateTabOnScroll();
            });
          }
          return false;
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              expandedHeight: 250.0,
              floating: false,
              pinned: true,
              backgroundColor: widget.color,
              title: AnimatedOpacity(
                opacity: _showDetailedAppBar ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: _showDetailedAppBar
                    ? Column(
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
                      )
                    : null,
              ),
              flexibleSpace: FlexibleSpaceBar(
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
                    isScrollable: true,
                    tabs: const [
                      Tab(text: 'Overview'),
                      Tab(text: 'Amenities'),
                      Tab(text: 'Rooms'),
                      Tab(text: 'Hotel Policy'),
                      Tab(text: 'Location'),
                    ],
                    onTap: (index) {
                      // Scroll to the corresponding section when tab is tapped
                      setState(() {
                        _isScrolling = true;
                        _currentTabIndex = index;
                      });

                      final keys = [
                        _overviewKey,
                        _amenitiesKey,
                        _roomsKey,
                        _policyKey,
                        _locationKey,
                      ];

                      if (keys[index].currentContext != null) {
                        final position = _getPositionFromKey(keys[index]);
                        if (position != null) {
                          _scrollController.jumpTo(position);
                        }
                      }
                    },
                  ),
                ),
              ),
            ),

            // Padding for the content
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Overview Section
                  Container(
                    key: _overviewKey,
                    height: 600,
                    margin: const EdgeInsets.symmetric(vertical: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'Overview Section',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  // Amenities Section
                  Container(
                    key: _amenitiesKey,
                    height: 600,
                    margin: const EdgeInsets.symmetric(vertical: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'Amenities Section',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  // Rooms Section
                  Container(
                    key: _roomsKey,
                    height: 600,
                    margin: const EdgeInsets.symmetric(vertical: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.amber[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Rooms Section',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        // Sample room card with booking button
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Deluxe King Room',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: widget.color,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.hotel, color: widget.color),
                                  const SizedBox(width: 8),
                                  const Text('1 King Bed'),
                                  const SizedBox(width: 16),
                                  Icon(Icons.people, color: widget.color),
                                  const SizedBox(width: 8),
                                  const Text('2 Guests'),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.wifi, color: widget.color),
                                  const SizedBox(width: 8),
                                  const Text('Free WiFi'),
                                  const SizedBox(width: 16),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        '\$149',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text('per night', style: TextStyle(color: Colors.grey)),
                                    ],
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => RoomSelectionScreen(
                                            hotelName: widget.hotelName,
                                            color: widget.color,
                                            checkInDate: _checkInDate,
                                            checkOutDate: _checkOutDate,
                                            roomName: 'Deluxe King Room',
                                            price: 149,
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: widget.color,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 12,
                                      ),
                                    ),
                                    child: const Text('Book Now'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Hotel Policy Section
                  Container(
                    key: _policyKey,
                    height: 600,
                    margin: const EdgeInsets.symmetric(vertical: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.purple[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'Hotel Policy Section',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  // Location Section
                  Container(
                    key: _locationKey,
                    height: 600,
                    margin: const EdgeInsets.symmetric(vertical: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'Location Section',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
      // Add bottom bar with updated visibility logic
      bottomNavigationBar: AnimatedContainer(
        height: _showBottomBar ? 80 : 0,
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _scrollToRooms,
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.color,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'See All Rooms',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
