import 'package:flutter/material.dart';
import '../models/rsvp_model.dart';
import '../models/rsvp_request.dart';
import '../services/rsvp_service.dart';

class RSVPButton extends StatefulWidget {
  final int eventId;
  final Function(String) onRSVPUpdated;

  const RSVPButton({
    super.key,
    required this.eventId,
    required this.onRSVPUpdated,
  });

  @override
  _RSVPButtonState createState() => _RSVPButtonState();
}

class _RSVPButtonState extends State<RSVPButton> {
  final RSVPService _rsvpService = RSVPService();
  String _currentStatus = '';
  bool _isLoading = true;
  RSVPModel? _rsvp;

  @override
  void initState() {
    super.initState();
    _loadUserRSVP();
  }

  Future<void> _loadUserRSVP() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final rsvp = await _rsvpService.getUserEventRSVP(widget.eventId);
      setState(() {
        _rsvp = rsvp;
        _currentStatus = rsvp?.status ?? '';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _currentStatus = '';
      });
    }
  }

  Future<void> _updateRSVP(String status) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final request = RSVPRequest(
        eventId: widget.eventId,
        status: status,
      );

      if (_rsvp != null) {
        await _rsvpService.updateRSVP(_rsvp!.id!, request);
      } else {
        await _rsvpService.createRSVP(request);
      }

      setState(() {
        _currentStatus = status;
        widget.onRSVPUpdated(status);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating RSVP: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
      await _loadUserRSVP();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              _currentStatus.isNotEmpty
                  ? 'Your response: $_currentStatus'
                  : 'RSVP to this event',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                _buildRSVPButton('Attending', Colors.green),
                _buildRSVPButton('Maybe', Colors.amber),
                _buildRSVPButton('Not Attending', Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRSVPButton(String status, Color color) {
    final isSelected = _currentStatus == status;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? color : Colors.grey[200],
        foregroundColor: isSelected ? Colors.white : Colors.black87,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: isSelected ? 4 : 0,
      ),
      onPressed: () => _updateRSVP(status),
      child: Text(status, style: const TextStyle(fontSize: 14)),
    );
  }
}
