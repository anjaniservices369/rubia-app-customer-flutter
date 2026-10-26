// =============================================================================
// WHAT : List of past bookings with paging.
// NOTES: Server: list-bookings.
// =============================================================================
import 'package:base_project_flutter/api_services/userApi.dart';
import 'package:base_project_flutter/constants/constants.dart';
import 'package:base_project_flutter/responsive.dart';
import 'package:base_project_flutter/views/Bookings/components/bookingCardWidget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
// >>> START: BookingHistoryList - screen/widget shell (the visible part is in its State class)
class BookingHistoryList extends StatefulWidget {
  const BookingHistoryList({
    Key? key,
    this.status,
    this.selectedServiceTypeId,
  }) : super(key: key);

  final status;
  final String? selectedServiceTypeId;

  @override
  State<BookingHistoryList> createState() => _BookingHistoryListState();
}
// <<< END: BookingHistoryList - screen/widget shell (the visible part is in its State class)

// >>> START: _BookingHistoryListState - the data and logic behind its screen
class _BookingHistoryListState extends State<BookingHistoryList> {
  ScrollController _scrollController = ScrollController();
  List<dynamic> bookingsData = [];
  bool showBottomSheet = false;

  int page = 0;
  int totalPages = 0;
  int totalCount = 0;
  UserAPI userAPI = UserAPI();
  bool isLoading = false;
  String errorMessage = '';

  // >>> START: initState - runs once when the screen opens - sets up data and listeners
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    fetchBookings(widget.selectedServiceTypeId);
  }
  // <<< END: initState - runs once when the screen opens - sets up data and listeners

  // >>> START: dispose - runs when the screen closes - frees resources and stops listeners
  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }
  // <<< END: dispose - runs when the screen closes - frees resources and stops listeners

  // >>> START: _scrollListener - scroll listener
  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (page < totalPages) {

        fetchBookings(widget.selectedServiceTypeId);
      }
    }
  }
  // <<< END: _scrollListener - scroll listener

  // >>> START: fetchBookings - fetches bookings
  Future<void> fetchBookings(selectedServiceTypeId) async {
    setState(() {
      isLoading = true;
    });

    try {
      dynamic data = await userAPI.fetchBookingsList(
        context,
        page.toString(),
        widget.status.toString(),
        widget.selectedServiceTypeId.toString(),
      );

      final List<dynamic> newBookings = data['bookings'];
      final paginationData = data['pagination'];

      setState(() {
        bookingsData.addAll(newBookings);
        totalPages = paginationData['total_pages'];
        totalCount = paginationData['total_count'];
        page++;
        isLoading = false;
        errorMessage = '';
      });
    } catch (error) {
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to fetch bookings.';
        });
      }
    }
  }
  // <<< END: fetchBookings - fetches bookings

  // >>> START: didUpdateWidget - reacts when the parent hands this widget new settings
  @override
  void didUpdateWidget(covariant BookingHistoryList oldWidget) {
    if (widget.selectedServiceTypeId != oldWidget.selectedServiceTypeId) {
      setState(() {
        page = 0; // Reset the page to fetch data from the beginning
        bookingsData.clear(); // Clear existing data
      });
      fetchBookings(widget.selectedServiceTypeId);
    }
    super.didUpdateWidget(oldWidget);
  }
  // <<< END: didUpdateWidget - reacts when the parent hands this widget new settings

  // >>> START: build - draws this screen/widget on the display
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (isLoading)
          Center(
              child: CircularProgressIndicator(
            color: tPrimaryColor,
          ))
        else if (errorMessage.isNotEmpty)
          Positioned.fill(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
              child: Container(
                  height: 20.h,
                  width: 20.w,
                  alignment: Alignment.center,
                  child: Text(
                    'No Bookings found',
                    style: GoogleFonts.mulish(
                      color: tDarkNavyblue,
                      fontWeight: FontWeight.bold,
                      fontSize: isTab(context) ? 9.sp : 18.sp,
                    ),
                  )),
            ),
          )
        else
          ListView.builder(
            controller: _scrollController,
            itemCount: bookingsData.length + 1,
            itemBuilder: (context, index) {
              if (index == bookingsData.length) {
                if (page < totalPages) {
                  // Show a loading indicator if there are more pages to fetch
                  return Center(child: CircularProgressIndicator());
                } else {
                  // Show a message when all bookings have been fetched
                  return Container();
                }
              }

              var booking = bookingsData[index];
              return BookingCardWidget(
                  bookingDetails: booking,
                  selectedServiceTypeId:
                      widget.selectedServiceTypeId.toString());
            },
          ),
      ],
    );
  }
  // <<< END: build - draws this screen/widget on the display
}
// <<< END: _BookingHistoryListState - the data and logic behind its screen
