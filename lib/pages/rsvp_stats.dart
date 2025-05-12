import 'package:flutter/material.dart';
import '../models/rsvp_counts.dart';
import '../services/rsvp_service.dart';

class RSVPStats extends StatefulWidget {
  final int eventId;

  const RSVPStats({
    Key? key,
    required this.eventId,
  }) : super(key: key);

  @override
  _RSVPStatsState createState() => _RSVPStatsState();
}

class _RSVPStatsState extends State<RSVPStats> {
  final RSVPService _rsvpService = RSVPService();
  bool _isLoading = true;
  RSVPCounts? _counts;

  @override
  void initState() {
    super.initState();
    _loadRSVPCounts();
  }

  Future<void> _loadRSVPCounts() async {
    setState(() => _isLoading = true);

    try {
      final counts = await _rsvpService.getEventRSVPCounts(widget.eventId);
      setState(() {
        _counts = counts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading RSVP stats: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_counts == null) {
      return const Center(child: Text('No RSVP data available'));
    }

    final total = _counts!.attending + _counts!.maybe + _counts!.notAttending;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'RSVP Statistics',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 12),
            const Divider(thickness: 1),
            _buildStatRow('Attending', _counts!.attending, Colors.green),
            _buildStatRow('Maybe', _counts!.maybe, Colors.orange),
            _buildStatRow('Not Attending', _counts!.notAttending, Colors.red),
            const Divider(thickness: 1),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Responses:',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  '$total',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Text(
            '$count',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
