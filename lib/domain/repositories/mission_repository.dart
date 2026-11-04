import '../../core/network/api_client.dart';
import '../entities/mission_entity.dart';

abstract class MissionRepository {
  Future<ApiResult<List<MissionTypeEntity>>> getMissionTypes();
  Future<ApiResult<List<MissionRequestEntity>>> getMissions();
  Future<ApiResult<MissionRequestEntity>> createMissionRequest(
    MissionRequestEntity request,
  );
}
