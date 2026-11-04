import '../../core/network/api_client.dart';
import '../../domain/entities/mission_entity.dart';
import '../../domain/repositories/mission_repository.dart';

class MissionRepositoryImpl implements MissionRepository {
  final ApiClient apiClient;

  final List<MissionTypeEntity> _types = const [
    MissionTypeEntity(
      id: 'mt-1',
      title: 'Client Site Inspection',
      description:
          'On-site technical review and operational assessment at client facilities.',
      iconName: 'business',
    ),
    MissionTypeEntity(
      id: 'mt-2',
      title: 'Field Audit & Survey',
      description:
          'Regional infrastructure survey and compliance verification.',
      iconName: 'assignment_turned_in',
    ),
    MissionTypeEntity(
      id: 'mt-3',
      title: 'Technical Support & Repair',
      description: 'Emergency hardware or software maintenance mission.',
      iconName: 'build',
    ),
    MissionTypeEntity(
      id: 'mt-4',
      title: 'Partner Training Workshop',
      description:
          'External training program execution for institutional partners.',
      iconName: 'school',
    ),
  ];

  final List<MissionRequestEntity> _missions = [
    MissionRequestEntity(
      id: 'MIS-2025-001',
      typeId: 'mt-1',
      typeTitle: 'Client Site Inspection',
      title: 'Annual Data Center Security Audit',
      description:
          'Conducting comprehensive physical and technical security review at Sector 4 Facility.',
      startDate: DateTime.now().add(const Duration(days: 2)),
      endDate: DateTime.now().add(const Duration(days: 5)),
      location: 'North Wing Hub, Office 4B',
      status: MissionStatus.approved,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    MissionRequestEntity(
      id: 'MIS-2025-002',
      typeId: 'mt-2',
      typeTitle: 'Field Audit & Survey',
      title: 'Fiber Network Expansion Survey',
      description:
          'Surveying proposed routes for rural network connectivity rollout.',
      startDate: DateTime.now().add(const Duration(days: 10)),
      endDate: DateTime.now().add(const Duration(days: 14)),
      location: 'Western Province Sector C',
      status: MissionStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    MissionRequestEntity(
      id: 'MIS-2025-003',
      typeId: 'mt-3',
      typeTitle: 'Technical Support & Repair',
      title: 'Main Server Grid Maintenance',
      description: 'Replacing hardware modules and verifying power redundancy.',
      startDate: DateTime.now().subtract(const Duration(days: 7)),
      endDate: DateTime.now().subtract(const Duration(days: 6)),
      location: 'Central Command Facility',
      status: MissionStatus.completed,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
  ];

  MissionRepositoryImpl({required this.apiClient});

  @override
  Future<ApiResult<List<MissionTypeEntity>>> getMissionTypes() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return ApiResult.success(_types);
  }

  @override
  Future<ApiResult<List<MissionRequestEntity>>> getMissions() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return ApiResult.success(List.from(_missions));
  }

  @override
  Future<ApiResult<MissionRequestEntity>> createMissionRequest(
    MissionRequestEntity request,
  ) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _missions.insert(0, request);
    return ApiResult.success(request);
  }
}
