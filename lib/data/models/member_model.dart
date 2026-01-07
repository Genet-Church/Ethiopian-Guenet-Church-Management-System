T? _enumFromString<T>(List<T> values, String? value) {
  if (value == null || value.isEmpty) return null;
  try {
    return values.firstWhere(
          (v) => v.toString().split('.').last.toUpperCase() == value.toUpperCase(),
      orElse: () => values.first,
    );
  } catch (e) {
    return null;
  }
}

T _parseEnum<T>(List<T> values, dynamic value, T defaultValue) {
  if (value is String) {
    return _enumFromString(values, value) ?? defaultValue;
  }
  return defaultValue;
}

enum Gender { MALE, FEMALE }

enum BaptismStatus { BAPTIZED, NOT_BAPTIZED, PENDING }

// Backend expects strict values: NONE, PRIMARY, SECONDARY, UNIVERSITY, POSTGRADUATE
enum EducationLevel { NONE, PRIMARY, SECONDARY, UNIVERSITY, POSTGRADUATE }

enum JobStatus { EMPLOYED, UNEMPLOYED, SELF_EMPLOYED, STUDENT, RETIRED }

enum MarriageStatus { SINGLE, MARRIED, DIVORCED, WIDOWED }

enum IncomeRange { LOW, MEDIUM, HIGH, VERY_HIGH }

enum MemberStatus { ACTIVE, INACTIVE, TRANSFER, DEAD, UNKNOWN }

class Address {
  final String city;
  final String subCity;
  final String woreda;
  final String placeName;

  Address({
    required this.city,
    required this.subCity,
    required this.woreda,
    required this.placeName,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      city: json['city'] as String? ?? '',
      subCity: json['subCity'] as String? ?? '',
      woreda: json['woreda'] as String? ?? '',
      placeName: json['placeName'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    // Backend requires all address fields to be non-empty strings
    return {
      'city': city.isNotEmpty ? city : 'N/A',
      'subCity': subCity.isNotEmpty ? subCity : 'N/A',
      'woreda': woreda.isNotEmpty ? woreda : 'N/A',
      'placeName': placeName.isNotEmpty ? placeName : 'N/A',
    };
  }
}

class Member {
  final String? id;
  final String fullName;
  final String birthDate;
  final String birthPlace;
  final String motherTongue;
  final Gender gender;
  final String phoneNumber;
  final BaptismStatus baptismStatus;
  final EducationLevel educationLevel;
  final JobStatus jobStatus;
  final MarriageStatus marriageStatus;
  final IncomeRange incomeRange;
  final MemberStatus memberStatus;
  final Address address;
  final bool deleted;
  final String? photoUrl;
  final String? bornAgainDate;
  final String? baptizedAt;
  final String? previousChurch;
  final String? reasonForTransfer;
  final String? fieldOfStudy;
  final String? workLocation;
  final String? statusChangedAt;
  final String? dateCreated;
  final String? dateUpdated;

  Member({
    this.id,
    required this.fullName,
    required this.birthDate,
    required this.birthPlace,
    required this.motherTongue,
    required this.gender,
    required this.phoneNumber,
    required this.baptismStatus,
    required this.educationLevel,
    required this.jobStatus,
    required this.marriageStatus,
    required this.incomeRange,
    required this.memberStatus,
    required this.address,
    this.deleted = false,
    this.photoUrl,
    this.bornAgainDate,
    this.baptizedAt,
    this.previousChurch,
    this.reasonForTransfer,
    this.fieldOfStudy,
    this.workLocation,
    this.statusChangedAt,
    this.dateCreated,
    this.dateUpdated,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'] as String?,
      fullName: json['fullName'] as String,
      photoUrl: json['photoUrl'] as String?,
      birthDate: json['birthDate'] as String,
      birthPlace: json['birthPlace'] as String,
      motherTongue: json['motherTongue'] as String,
      gender: _parseEnum(Gender.values, json['gender'], Gender.MALE),
      phoneNumber: json['phoneNumber'] as String,
      bornAgainDate: json['bornAgainDate'] as String?,
      baptismStatus: _parseEnum(
        BaptismStatus.values,
        json['baptismStatus'],
        BaptismStatus.PENDING,
      ),
      baptizedAt: json['baptizedAt'] as String?,
      previousChurch: json['previousChurch'] as String?,
      reasonForTransfer: json['reasonForTransfer'] as String?,
      educationLevel: _parseEnum(
        EducationLevel.values,
        json['educationLevel'],
        EducationLevel.NONE,
      ),
      fieldOfStudy: json['fieldOfStudy'] as String?,
      jobStatus: _parseEnum(
        JobStatus.values,
        json['jobStatus'],
        JobStatus.UNEMPLOYED,
      ),
      workLocation: json['workLocation'] as String?,
      marriageStatus: _parseEnum(
        MarriageStatus.values,
        json['marriageStatus'],
        MarriageStatus.SINGLE,
      ),
      incomeRange: _parseEnum(
        IncomeRange.values,
        json['incomeRange'],
        IncomeRange.LOW,
      ),
      memberStatus: _parseEnum(
        MemberStatus.values,
        json['memberStatus'],
        MemberStatus.UNKNOWN,
      ),
      address: Address.fromJson(json['address'] as Map<String, dynamic>),
      deleted: json['deleted'] as bool? ?? false,
      statusChangedAt: json['statusChangedAt'] as String?,
      dateCreated: json['dateCreated'] as String?,
      dateUpdated: json['dateUpdated'] as String?,
    );
  }

  String _cleanDate(String dateStr) {
    if (dateStr.endsWith('Z')) return dateStr;
    return dateStr;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'fullName': fullName,
      'birthDate': _cleanDate(birthDate),
      // Backend requires these fields to be non-empty strings
      'birthPlace': birthPlace.isNotEmpty ? birthPlace : 'N/A',
      'motherTongue': motherTongue.isNotEmpty ? motherTongue : 'N/A',
      'gender': gender.name,
      'phoneNumber': phoneNumber,
      'baptismStatus': baptismStatus.name,
      'educationLevel': educationLevel.name,
      'jobStatus': jobStatus.name,
      'marriageStatus': marriageStatus.name,
      'incomeRange': incomeRange.name,
      'memberStatus': memberStatus.name,
      'address': address.toJson(),
      'deleted': deleted,
    };

    if (photoUrl != null && photoUrl!.isNotEmpty) data['photoUrl'] = photoUrl;
    if (bornAgainDate != null && bornAgainDate!.isNotEmpty) {
      data['bornAgainDate'] = _cleanDate(bornAgainDate!);
    }
    if (baptizedAt != null && baptizedAt!.isNotEmpty) {
      data['baptizedAt'] = _cleanDate(baptizedAt!);
    }
    if (previousChurch != null && previousChurch!.isNotEmpty) {
      data['previousChurch'] = previousChurch;
    }
    if (reasonForTransfer != null && reasonForTransfer!.isNotEmpty) {
      data['reasonForTransfer'] = reasonForTransfer;
    }
    if (fieldOfStudy != null && fieldOfStudy!.isNotEmpty) {
      data['fieldOfStudy'] = fieldOfStudy;
    }
    if (workLocation != null && workLocation!.isNotEmpty) {
      data['workLocation'] = workLocation;
    }
    // Note: statusChangedAt is not sent on member creation
    // It's set by the backend when member status changes

    return data;
  }
}