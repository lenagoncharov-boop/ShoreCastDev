import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../models/location_model.dart';
import '../../providers/locations_provider.dart';
import '../../services/geocoding_service.dart';
import '../../widgets/app_gradient_background.dart';

class LocationPickerScreen extends ConsumerStatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  ConsumerState<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends ConsumerState<LocationPickerScreen> {
  final _searchController = TextEditingController();
  List<CoastLocation> _results = [];
  bool _searching = false;
  String? _searchError;
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () => _runSearch(query));
  }

  Future<void> _runSearch(String query) async {
    if (query.trim().length < 2) {
      setState(() {
        _results = [];
        _searchError = null;
      });
      return;
    }
    setState(() {
      _searching = true;
      _searchError = null;
    });
    try {
      final results = await GeocodingService.search(query);
      if (!mounted) return;
      setState(() {
        _results = results;
        _searching = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _searchError = AppLocalizations.of(context)!.searchFailed('$e');
        _searching = false;
      });
    }
  }

  Future<void> _useMyLocation() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final permission = await Geolocator.checkPermission();
      var granted = permission;
      if (granted == LocationPermission.denied) {
        granted = await Geolocator.requestPermission();
      }
      if (granted == LocationPermission.denied || granted == LocationPermission.deniedForever) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.locationPermissionDenied)),
        );
        return;
      }
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.locationServicesOff)),
        );
        return;
      }
      final position = await Geolocator.getCurrentPosition();
      final loc = CoastLocation(
        id: CoastLocation.idFor(position.latitude, position.longitude),
        name: l10n.myLocationName,
        lat: position.latitude,
        lon: position.longitude,
      );
      await ref.read(locationsProvider.notifier).setActive(loc);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.couldntGetLocation('$e'))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationsState = ref.watch(locationsProvider);
    final l10n = AppLocalizations.of(context)!;

    return AppGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: Text(l10n.chooseCoast)),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: _onQueryChanged,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: l10n.searchHint,
                    hintStyle: const TextStyle(color: AppColors.textFaint),
                    prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textFaint),
                    filled: true,
                    fillColor: AppColors.panelNavy,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: _useMyLocation,
                  icon: const Icon(Icons.my_location_rounded),
                  label: Text(l10n.useMyLocation),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.accentCyan,
                    side: const BorderSide(color: AppColors.accentCyan),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: locationsState.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text('$e')),
                    data: (state) => ListView(
                      children: [
                        if (_searching) const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator(color: AppColors.accentCyan)),
                        ),
                        if (_searchError != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(_searchError!, style: const TextStyle(color: AppColors.poorRed)),
                          ),
                        if (_results.isNotEmpty) ...[
                          _SectionLabel(l10n.searchResults),
                          for (final loc in _results)
                            _LocationTile(
                              location: loc,
                              isActive: loc.id == state.active.id,
                              onTap: () async {
                                await ref.read(locationsProvider.notifier).setActive(loc);
                                if (context.mounted) Navigator.of(context).pop();
                              },
                            ),
                        ],
                        _SectionLabel(l10n.savedCoasts),
                        for (final loc in state.saved)
                          _LocationTile(
                            location: loc,
                            isActive: loc.id == state.active.id,
                            onTap: () async {
                              await ref.read(locationsProvider.notifier).setActive(loc);
                              if (context.mounted) Navigator.of(context).pop();
                            },
                            onRemove: state.saved.length > 1
                                ? () => ref.read(locationsProvider.notifier).removeLocation(loc.id)
                                : null,
                          ),
                        _SectionLabel(l10n.suggestedCoasts),
                        for (final loc in suggestedCoasts)
                          _LocationTile(
                            location: loc,
                            isActive: loc.id == state.active.id,
                            onTap: () async {
                              await ref.read(locationsProvider.notifier).setActive(loc);
                              if (context.mounted) Navigator.of(context).pop();
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 6),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
          color: AppColors.textFaint,
        ),
      ),
    );
  }
}

class _LocationTile extends StatelessWidget {
  final CoastLocation location;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback? onRemove;

  const _LocationTile({
    required this.location,
    required this.isActive,
    required this.onTap,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          isActive ? Icons.radio_button_checked_rounded : Icons.place_outlined,
          color: isActive ? AppColors.accentCyan : AppColors.textSecondary,
        ),
        title: Text(location.name),
        subtitle: location.region == null ? null : Text(location.region!),
        trailing: onRemove == null
            ? null
            : IconButton(
                icon: const Icon(Icons.delete_outline_rounded, color: AppColors.textFaint),
                onPressed: onRemove,
              ),
      ),
    );
  }
}
