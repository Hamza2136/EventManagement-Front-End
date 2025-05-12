import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:smart_event_frontend/pages/rsvp_button.dart';
import 'package:smart_event_frontend/pages/rsvp_stats.dart';
import '../models/event_model.dart';

class RSVPDetailScreen extends StatefulWidget {
  final EventModel event;

  const RSVPDetailScreen({
    super.key,
    required this.event,
  });

  @override
  _RSVPDetailScreenState createState() => _RSVPDetailScreenState();
}

class _RSVPDetailScreenState extends State<RSVPDetailScreen> {
  int _refreshCounter = 0;

  void _onRSVPUpdated(String status) {
    setState(() {
      _refreshCounter++;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Your RSVP has been updated to $status'),
        backgroundColor: Colors.green,
      ),
    );
  }

  String _formatDateTime(String dateStr) {
    final DateTime dateTime = DateTime.parse(dateStr);
    return DateFormat('EEE, MMM d - h:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: HexColor("#4a43ec"),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Event Details",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 22,
              ),
            ),
            
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (widget.event.imageUrl != null)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                child: Image.network(
                  widget.event.imageUrl!,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.event.title,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(Icons.calendar_today, _formatDateTime(widget.event.date)),
                      _buildInfoRow(Icons.access_time,
                          '${_formatDateTime(widget.event.date)} - ${_formatDateTime(widget.event.endDate)}'),
                      _buildInfoRow(Icons.location_on, widget.event.location),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          children: [
                            RSVPButton(
                              eventId: widget.event.id,
                              onRSVPUpdated: _onRSVPUpdated,
                            ),
                            const SizedBox(height: 16),
                            RSVPStats(
                              key: ValueKey(_refreshCounter),
                              eventId: widget.event.id,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Description',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.event.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: HexColor("#4a43ec"), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}
