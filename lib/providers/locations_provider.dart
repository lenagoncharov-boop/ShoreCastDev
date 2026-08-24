import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants.dart';
import '../models/location_model.dart';
import '../services/location_storage_service.dart';

class LocationsState {
  final List<CoastLocation> saved;
  final CoastLocation active;

  const LocationsState({required this.saved, required this.active});
}

const _bootstrapLocation = CoastLocation(
  id: 'bootstrap_default',
  name: DefaultLocation.name,
  lat: DefaultLocation.lat,
  lon: DefaultLocation.lon,
  isFavorite: true,
);

/// Starts with a synchronous, known-good default location so
/// [forecastProvider] never has to special-case "no location yet" — the
/// real persisted location (if any) replaces it a moment later once
/// SharedPreferences has loaded.
class LocationsNotifier extends StateNotifier<AsyncValue<LocationsState>> {
  LocationsNotifier()
      : super(const AsyncValue.data(
          LocationsState(saved: [_bootstrapLocation], active: _bootstrapLocation),
        )) {
    _load();
  }

  Future<void> _load() async {
    final saved = await LocationStorageService.loadSaved();
    final activeId = await LocationStorageService.loadActiveLocationId();
    final active = saved.firstWhere(
      (l) => l.id == activeId,
      orElse: () => saved.first,
    );
    state = AsyncValue.data(LocationsState(saved: saved, active: active));
  }

  Future<void> addLocation(CoastLocation location) async {
    final current = state.value;
    if (current == null) return;
    final exists = current.saved.any((l) => l.id == location.id);
    final updated = exists ? current.saved : [...current.saved, location];
    await LocationStorageService.saveAll(updated);
    state = AsyncValue.data(LocationsState(saved: updated, active: current.active));
  }

  Future<void> removeLocation(String id) async {
    final current = state.value;
    if (current == null) return;
    final updated = current.saved.where((l) => l.id != id).toList();
    if (updated.isEmpty) return; // always keep at least one
    await LocationStorageService.saveAll(updated);
    final newActive = current.active.id == id ? updated.first : current.active;
    if (newActive.id != current.active.id) {
      await LocationStorageService.saveActiveLocationId(newActive.id);
    }
    state = AsyncValue.data(LocationsState(saved: updated, active: newActive));
  }

  Future<void> setActive(CoastLocation location) async {
    final current = state.value;
    if (current == null) return;
    final exists = current.saved.any((l) => l.id == location.id);
    final updatedSaved = exists ? current.saved : [...current.saved, location];
    if (!exists) {
      await LocationStorageService.saveAll(updatedSaved);
    }
    await LocationStorageService.saveActiveLocationId(location.id);
    state = AsyncValue.data(LocationsState(saved: updatedSaved, active: location));
  }
}

final locationsProvider = StateNotifierProvider<LocationsNotifier, AsyncValue<LocationsState>>(
  (ref) => LocationsNotifier(),
);

/// Convenience provider: the currently active coast, always available
/// synchronously (falls back to the bootstrap default while real saved
/// data is still loading from disk).
final activeLocationProvider = Provider<CoastLocation>(
  (ref) => ref.watch(locationsProvider).value?.active ?? _bootstrapLocation,
);
