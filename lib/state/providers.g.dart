// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$usersHash() => r'f683a41c6e037b8e6b5a4a7a72ec6dd53a83a3d6';

/// See also [users].
@ProviderFor(users)
final usersProvider = AutoDisposeFutureProvider<List<UserModel>>.internal(
  users,
  name: r'usersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$usersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UsersRef = AutoDisposeFutureProviderRef<List<UserModel>>;
String _$currentPastorHash() => r'26e4780f82f95cfc606b72f044dce4a5075187bb';

/// See also [currentPastor].
@ProviderFor(currentPastor)
final currentPastorProvider = AutoDisposeFutureProvider<Pastor?>.internal(
  currentPastor,
  name: r'currentPastorProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentPastorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentPastorRef = AutoDisposeFutureProviderRef<Pastor?>;
String _$memberDetailsHash() => r'e257d591887caeb933522b30789257a38474898a';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [memberDetails].
@ProviderFor(memberDetails)
const memberDetailsProvider = MemberDetailsFamily();

/// See also [memberDetails].
class MemberDetailsFamily extends Family<AsyncValue<Member>> {
  /// See also [memberDetails].
  const MemberDetailsFamily();

  /// See also [memberDetails].
  MemberDetailsProvider call(String memberId) {
    return MemberDetailsProvider(memberId);
  }

  @override
  MemberDetailsProvider getProviderOverride(
    covariant MemberDetailsProvider provider,
  ) {
    return call(provider.memberId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'memberDetailsProvider';
}

/// See also [memberDetails].
class MemberDetailsProvider extends AutoDisposeFutureProvider<Member> {
  /// See also [memberDetails].
  MemberDetailsProvider(String memberId)
    : this._internal(
        (ref) => memberDetails(ref as MemberDetailsRef, memberId),
        from: memberDetailsProvider,
        name: r'memberDetailsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$memberDetailsHash,
        dependencies: MemberDetailsFamily._dependencies,
        allTransitiveDependencies:
            MemberDetailsFamily._allTransitiveDependencies,
        memberId: memberId,
      );

  MemberDetailsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.memberId,
  }) : super.internal();

  final String memberId;

  @override
  Override overrideWith(
    FutureOr<Member> Function(MemberDetailsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MemberDetailsProvider._internal(
        (ref) => create(ref as MemberDetailsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        memberId: memberId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Member> createElement() {
    return _MemberDetailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MemberDetailsProvider && other.memberId == memberId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, memberId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MemberDetailsRef on AutoDisposeFutureProviderRef<Member> {
  /// The parameter `memberId` of this provider.
  String get memberId;
}

class _MemberDetailsProviderElement
    extends AutoDisposeFutureProviderElement<Member>
    with MemberDetailsRef {
  _MemberDetailsProviderElement(super.provider);

  @override
  String get memberId => (origin as MemberDetailsProvider).memberId;
}

String _$pastorsHash() => r'5010c7b4db5e0879e70471527560b9701307c136';

/// See also [Pastors].
@ProviderFor(Pastors)
final pastorsProvider =
    AutoDisposeAsyncNotifierProvider<Pastors, List<Pastor>>.internal(
      Pastors.new,
      name: r'pastorsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$pastorsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Pastors = AutoDisposeAsyncNotifier<List<Pastor>>;
String _$churchesHash() => r'5dfdf00548c57e77479a501c8d85730191db3b4c';

/// See also [Churches].
@ProviderFor(Churches)
final churchesProvider =
    AutoDisposeAsyncNotifierProvider<Churches, List<Church>>.internal(
      Churches.new,
      name: r'churchesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$churchesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Churches = AutoDisposeAsyncNotifier<List<Church>>;
String _$departmentsHash() => r'cc275d35f0c9e8e930cb94208ad7fc3c36576685';

/// See also [Departments].
@ProviderFor(Departments)
final departmentsProvider =
    AutoDisposeAsyncNotifierProvider<Departments, List<Department>>.internal(
      Departments.new,
      name: r'departmentsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$departmentsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Departments = AutoDisposeAsyncNotifier<List<Department>>;
String _$servantsHash() => r'cb774f509975fa07d382efdfae50a715c41e226e';

/// See also [Servants].
@ProviderFor(Servants)
final servantsProvider =
    AutoDisposeAsyncNotifierProvider<Servants, List<Servant>>.internal(
      Servants.new,
      name: r'servantsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$servantsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Servants = AutoDisposeAsyncNotifier<List<Servant>>;
String _$membersHash() => r'a0f15ab3fe092566f33ea912b52dab78af210ccf';

/// See also [Members].
@ProviderFor(Members)
final membersProvider = AutoDisposeNotifierProvider<Members, void>.internal(
  Members.new,
  name: r'membersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$membersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Members = AutoDisposeNotifier<void>;
String _$membersListHash() => r'0f7ae5cc16da4897603a8d3eaa83ab0f72cdf911';

/// See also [MembersList].
@ProviderFor(MembersList)
final membersListProvider =
    AutoDisposeAsyncNotifierProvider<MembersList, MemberListState>.internal(
      MembersList.new,
      name: r'membersListProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$membersListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$MembersList = AutoDisposeAsyncNotifier<MemberListState>;
String _$activityLogHash() => r'd75c30a92eaa0a9ee12e3701e352400f5cdb9e9c';

/// See also [ActivityLog].
@ProviderFor(ActivityLog)
final activityLogProvider =
    AutoDisposeAsyncNotifierProvider<
      ActivityLog,
      List<ActivityLogItem>
    >.internal(
      ActivityLog.new,
      name: r'activityLogProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$activityLogHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ActivityLog = AutoDisposeAsyncNotifier<List<ActivityLogItem>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
