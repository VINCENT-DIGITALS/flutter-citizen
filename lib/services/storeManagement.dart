import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';

class FMTCManagement {
  final String storeName = 'mapCache';
  final FMTCStore _store = FMTCStore('mapCache');

  Future<void> checkAndManageStore() async {
    final mgmt = _store.manage;

    bool storeExists = await mgmt.ready;
    if (storeExists) {
      print('Store exists and is ready for use.');

      // Get store statistics
      final stats = _store.stats;
      final allStats = await stats.all;
      print(allStats);

      // Optionally, get real size of all stores
      final realSize = await FMTCRoot.stats.realSize;
      print('Total size across all stores: $realSize');
    } else {
      print('Store does not exist. Creating it now...');
      await mgmt.create();
    }
  }

  Future<void> deleteStore() async {
    await _store.manage.delete();
    print('Store deleted.');
  }

  Future<void> resetStore() async {
    await _store.manage.reset();
    print('Store reset.');
  }

  Future<void> renameStore(String newStoreName) async {
    await _store.manage.rename(newStoreName);
    print('Store renamed to $newStoreName.');
  }
}
