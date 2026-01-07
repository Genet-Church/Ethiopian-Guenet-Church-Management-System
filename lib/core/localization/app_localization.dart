import 'package:flutter/material.dart';

class AppLocalization {
  final Locale locale;

  AppLocalization(this.locale);

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'settings': 'Settings',
      'customize_experience': 'Customize your experience',
      'power_user': 'POWER USER',
      'global_command_palette': 'Global Command Palette',
      'command_palette_desc':
      'Quickly access any feature, navigate screens, or change settings instantly',
      'appearance': 'APPEARANCE',
      'theme_mode': 'Theme Mode',
      'choose_visual_preference': 'Choose your visual preference',
      'light': 'Light',
      'dark': 'Dark',
      'system': 'System',
      'localization': 'LOCALIZATION',
      'language': 'Language',
      'select_language': 'Select your preferred language',
      'date_format': 'Date Format',
      'choose_calendar_format': 'Choose calendar format',
      'gregorian': 'Gregorian',
      'ethiopian': 'Ethiopian',
      'about': 'ABOUT',
      'version': 'Version',
      'latest': 'Latest',
      'success': 'Success!',
      'error': 'Error',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'edit': 'Edit',
      'save': 'Save',
      'save_changes': 'Save Changes',
      'view': 'VIEW',
      'assign': 'ASSIGN',
      'required': 'Required',
      'action_required': 'Action Required',
      'confirm_deletion': 'Confirm Deletion',
      'deleted': 'Deleted',
      'search': 'Search',
      'clear': 'Clear',
      'none_unassigned': 'None (Unassigned)',
      'select': 'Select',
      'validation_error': 'Validation Error',
      'add_failed': 'Add Failed',
      'update_failed': 'Update Failed',
      'delete_failed': 'Delete Failed',
      'delete_confirmation':
      'Are you sure you want to delete "{name}"? This action cannot be undone.',
      'dashboard': 'Dashboard',
      'live_updates': 'Live Updates',
      'search_actions': 'Search actions...',
      'search_actions_pages': 'Search actions or pages...',
      'profile_settings': 'Profile Settings',
      'my_profile': 'My Profile',
      'light_mode': 'Light Mode',
      'dark_mode': 'Dark Mode',
      'logout': 'Logout',
      'select_church': 'Select Church',
      'no_results_found': 'No results found.',
      'error_searching': 'Error searching.',
      'welcome_back': 'Welcome Back',
      'sign_in_prompt': 'Sign in to access your account',
      'username_or_email': 'Username or Email',
      'password_required': 'Password is required',
      'remember_me': 'Remember Me',
      'forgot_password': 'Forgot Password?',
      'sign_in': 'Sign In',
      'need_help': 'Need Help?',
      'contact_admin': 'Contact Administrator',
      'welcome_to_ministry': 'Welcome to Ministry Portal',
      'nav_dashboard': 'Dashboard',
      'nav_church_admin': 'Church Admin',
      'nav_churches': 'Churches',
      'nav_pastors': 'Pastors',
      'nav_departments': 'Departments',
      'nav_servants': 'Servants',
      'nav_members': 'Members',
      'nav_add_member': 'Add Member',
      'nav_show_members': 'Show Members',
      'nav_analytics': 'Analytics',
      'nav_settings': 'Settings',
      'church_management': 'Church Management',
      'assign_to_enable': '(Assign to a church to enable)',
      'must_be_assigned':
      'You must be assigned to a church to access this feature.',
      'action_disabled': 'Action Disabled',
      'welcome_message': 'Welcome to the Genet Church Portal!',
      'good_morning': 'Good morning',
      'good_afternoon': 'Good afternoon',
      'good_evening': 'Good evening',
      'happening_today': "Here's what's happening in your church today.",
      'timeframe_7d': '7 Days',
      'timeframe_30d': '30 Days',
      'timeframe_1y': '1 Year',
      'timeframe_all': 'All Time',
      'quick_stats': 'Quick Stats',
      'view_full_report': 'View Full Report',
      'donations': 'Donations',
      'coming_soon': 'Coming Soon',
      'no_celebration': 'No Celebration',
      'could_not_load_analytics': 'Could not load analytics',
      'total_churches': 'Total Churches',
      'total_pastors': 'Total Pastors',
      'total_members': 'Total Members',
      'total_servants': 'Total Servants',
      'churches_assigned': 'Churches Assigned',
      'your_members': 'Your Members',
      'your_servants': 'Your Servants',
      'your_departments': 'Your Departments',
      'recent_activity': 'Recent Activity',
      'latest_updates': 'Latest updates and changes',
      'activity_log': 'Activity Log',
      'activity_log_desc':
      'A chronological list of all major events and changes in the system.',
      'no_activities_yet': 'No Activities Yet',
      'no_activities_desc':
      'Activity logs will appear here as actions are performed in the system.',
      'failed_load_activities': 'Failed to Load Activities',
      'church_records': 'Church Records',
      'manage_churches_desc':
      'Manage all church branches within the ministry network',
      'add_church': 'Add Church',
      'search_church_hint': 'Search by church name...',
      'no_churches_match': 'No Churches Match Your Search',
      'no_churches_found': 'No Churches Found',
      'adjust_search_terms': 'Try adjusting your search terms.',
      'add_first_church_desc': 'Add your first church to get started.',
      'add_first_church': 'Add First Church',
      'new_church_details': 'New Church Details',
      'new_church_desc': 'Add a new church branch to the database.',
      'save_church': 'Save Church',
      'church_name': 'New Church Name',
      'church_name_empty': 'Church name cannot be empty',
      'church_name_required': 'Church name is required',
      'google_maps_link': 'Google Maps Link (Optional)',
      'establishment_date_optional': 'Establishment Date (Optional)',
      'church_establishment_date': 'Establishment Date',
      'clear_form': 'Clear Form',
      'church_added': 'Church added successfully',
      'failed_add_church': 'Failed to add church. Please try again.',
      'invalid_form': 'Invalid Form',
      'correct_errors': 'Please correct the errors in the form.',
      'view_on_map': 'View on Map',
      'head_office_id': 'Head Office ID',
      'est': 'Est.',
      'edit_church': 'Edit Church',
      'church_updated': 'Church Updated!',
      'church_update_success':
      'Changes to "{name}" have been saved successfully.',
      'church_deleted': 'Church Deleted',
      'church_delete_success': '"{name}" has been successfully removed.',
      'failed_delete_church': 'Failed to delete church.',
      'has_location': 'Has Location',
      'sort_by': 'Sort By',
      'name_asc': 'Name (A-Z)',
      'name_desc': 'Name (Z-A)',
      'newest_first': 'Newest First',
      'oldest_first': 'Oldest First',
      'pastor_records': 'Pastor Records',
      'manage_pastors_desc':
      'Manage and oversee all pastoral staff across your ministry',
      'add_new_pastor': 'Add New Pastor',
      'search_pastor_hint': 'Search by name or email...',
      'no_pastors_match': 'No Pastors Match Your Filters',
      'no_pastors_found': 'No Pastors Found',
      'add_first_pastor_desc': 'Add your first pastor to get started.',
      'add_first_pastor': 'Add First Pastor',
      'confirm_pastor_deletion':
      'Are you sure you want to delete pastor {name}?',
      'pastor_deleted': '{name} has been deleted.',
      'failed_delete_pastor': 'Failed to delete pastor.',
      'failed_delete_pastor_server':
      'Server Error: Unable to delete pastor due to linked records.',
      'assign_church_to': 'Assign Church to {name}',
      'unassign_church': 'Unassign Church',
      'unassigned_success': 'Unassigned Successfully',
      'pastor_removed_church': 'Pastor has been removed from the church.',
      'failed_unassign': 'Failed to Unassign',
      'church_assigned': 'Church assigned.',
      'edit_pastor': 'Edit Pastor',
      'pastor_updated_success': 'Pastor details have been updated.',
      'failed_update': 'Failed to update details.',
      'pastor_added': 'Pastor Added',
      'pastor_added_success': '{name} has been successfully added.',
      'failed_add_pastor': 'Failed to Add',
      'add_pastor': 'Add Pastor',
      'full_name': 'Full Name',
      'email': 'Email',
      'temporary_password': 'Temporary Password',
      'min_6_chars': 'Min 6 characters',
      'assign_church_optional': 'Assign to Church (Optional)',
      'could_not_load_churches': 'Could not load churches',
      'new_pastor_details': 'New Pastor Details',
      'new_pastor_desc': 'Enter the information for the new pastor.',
      'pastor_full_name': 'Pastor Full Name',
      'name_empty': 'Name cannot be empty',
      'password_min_6': 'Password must be at least 6 characters',
      'pastor_added_message': 'has been added as a pastor.',
      'department_records': 'Department Records',
      'manage_departments_desc':
      'Manage all departments within the currently selected church.',
      'add_new_department': 'Add New Department',
      'select_church_manage_departments':
      'Please select a church to manage departments.',
      'search_department_hint': 'Search by department name...',
      'no_departments_match': 'No Departments Match Your Search',
      'no_departments_found': 'No Departments Found',
      'add_first_department_desc':
      'Add your first department to organize your servants.',
      'no_departments_yet': 'No departments have been created yet.',
      'add_first_department': 'Add First Department',
      'department_name': 'Department Name',
      'department': 'Department',
      'add_department': 'Add Department',
      'department_added_success': 'Department "{name}" added successfully.',
      'department_updated_success': 'Department updated successfully.',
      'confirm_department_deletion':
      'Delete department "{name}"? This action cannot be undone.',
      'department_removed': 'Department "{name}" was removed.',
      'failed_delete_department': 'Could not delete department.',
      'edit_department': 'Edit "{name}"',
      'active': 'Active',
      'servants_count': '{count} Servants',
      'select_church_first': 'Please select a church from the header first.',
      'servant_records': 'Servant Records',
      'manage_servants_desc':
      'Manage all servants within the currently selected church.',
      'add_new_servant': 'Add New Servant',
      'select_church_add_servant': 'Please select a church to add a servant.',
      'select_church_manage_servants':
      'Please select a church to manage servants.',
      'search_servant_hint': 'Search by name or email...',
      'no_servants_match': 'No Servants Match Your Filters',
      'no_servants_found': 'No Servants Found',
      'add_first_servant_desc':
      'Add your first servant to begin building your team.',
      'no_servants_yet': 'There are no servants registered yet.',
      'add_first_servant': 'Add First Servant',
      'assign_department': 'Assign Department',
      'select_department': 'Select a Department',
      'department_assigned': 'Department assigned.',
      'failed_assign_department': 'Failed to assign department.',
      'edit_servant': 'Edit Servant',
      'new_full_name': 'New Full Name',
      'servant_updated_success': 'Servant information has been updated.',
      'failed_update_servant': 'Failed to update servant.',
      'confirm_servant_deletion': 'Delete servant "{name}"?',
      'servant_removed': 'Servant "{name}" has been removed.',
      'failed_remove_servant': 'Failed to remove servant.',
      'add_servant': 'Add Servant',
      'servant_added_success': 'Servant "{name}" added successfully.',
      'failed_add_servant': 'Failed to add servant.',
      'could_not_load_departments': 'Could not load departments.',
      'member_records': 'Member Records',
      'member_records_desc': 'A list of all registered members in the church.',
      'addNewMember': 'Add New Member',
      'add_new_member': 'Add New Member',
      'select_church_hint': 'Please select a church to view members.',
      'search_member_hint': 'Search by name or phone number...',
      'no_members_match': 'No Members Match Your Filters',
      'no_members_found': 'No Members Found',
      'adjust_filter_criteria': 'Try adjusting your search criteria.',
      'add_first_member_desc': 'Add your first member to get started.',
      'no_members_registered': 'No members have been registered yet.',
      'add_first_member': 'Add First Member',
      'confirm_member_deletion':
      'Delete member "{name}"? This cannot be undone.',
      'member_deleted_success': 'Member deleted successfully.',
      'delete_member_failed': 'Failed to delete member.',
      'personal_information': 'Personal Information',
      'phone': 'Phone',
      'birth_date': 'Birth Date',
      'birth_place': 'Birth Place',
      'membership_details': 'Membership Details',
      'status': 'Status',
      'status_changed': 'Status Changed',
      'baptized_date': 'Baptized Date',
      'address': 'Address',
      'city_sub_city': 'City / Sub-City',
      'woreda': 'Woreda',
      'place_name': 'Place Name',
      'gender': 'Gender',
      'male': 'Male',
      'female': 'Female',
      'new_believer': 'New Believer',
      'inactive': 'Inactive',
      'personal_info': 'Personal Info',
      'basic_details': 'Basic details',
      'location_details': 'Location details',
      'additional_info': 'Additional',
      'church_info': 'Church info',
      'incomplete_form': 'Incomplete Form',
      'complete_all_fields': 'Please complete all required fields.',
      'church_required': 'Church Required',
      'select_church_before_adding':
      'Please select a church before adding a member.',
      'provide_born_again_date': 'Please provide the born again date.',
      'member_added_success': 'Member added successfully.',
      'failed_add_member': 'Failed to add member',
      'register_new_member': 'Register New Member',
      'fill_details_add_member': 'Fill in the details to add a new member',
      'previous_step': 'Previous',
      'continue_step': 'Continue',
      'save_member': 'Save Member',
      'phone_number': 'Phone Number',
      'mother_tongue': 'Mother Tongue',
      'city': 'City',
      'sub_city': 'Sub-City',
      'specific_place_name': 'Specific Place Name',
      'education_level': 'Education Level',
      'job_status': 'Job Status',
      'marriage_status': 'Marriage Status',
      'income_range': 'Income Range',
      'baptism_status': 'Baptism Status',
      'born_again_date': 'Born Again Date',
      'baptism_date': 'Baptism Date',
      'baptism_date_required': 'Baptism Date is required',
      'phone_numbers_only': 'Phone must contain only numbers',
      'select_date': 'Please select a date',
      'required_field': 'Required',
      'analytics_dashboard': 'Analytics Dashboard',
      'analytics_desc': 'Real-time insights and performance metrics',
      'updated_just_now': 'Updated just now',
      'live_data': 'Live Data',
      'export_report': 'Export Report',
      'loading_analytics': 'Loading analytics...',
      'failed_load_analytics': 'Failed to load analytics data',
      'member_gender_dist': 'Member Gender Distribution',
      'total_label': 'Total: {count}',
      'member_status': 'Member Status',
      'no_data_available': 'No data available.',
      'members_label': 'Members',
    },
    'am': {
      'settings': 'ማስተካከያዎች',
      'customize_experience': 'መተግበሪያውን ያስተካክሉ',
      'power_user': 'ፈጣን እርምጃዎች',
      'global_command_palette': 'ግሎባል ትዕዛዝ ፓሌት',
      'command_palette_desc':
      'የፈለጉት ቦታ በፍጥነት ይድረሱ፣ ስክሪኖችን ይፈልጉ ወይም ማስተካከያዎችን ወዲያውኑ ይቀይሩ',
      'appearance': 'ገጽታ',
      'theme_mode': 'የገጽታ አይነት',
      'choose_visual_preference': 'የገጽታ ምርጫዎን ይምረጡ',
      'light': 'ብርሃናማ',
      'dark': 'ጨለማ',
      'system': 'እንደ ሲስተሙ ገጽታ',
      'localization': 'ቋንቋ እና ቀን',
      'language': 'ቋንቋ',
      'select_language': 'የሚፈልጉትን ቋንቋ ይምረጡ',
      'date_format': 'የቀን አቆጣጠር',
      'choose_calendar_format': 'የቀን መቁጠሪያ አይነት ይምረጡ',
      'gregorian': 'ግሪጎሪያን',
      'ethiopian': 'ኢትዮጵያዊ',
      'about': 'ስለ',
      'version': 'ስሪት',
      'latest': 'የዘመነ',
      'success': 'ተሳክቷል!',
      'error': 'ስህተት',
      'cancel': 'ይቅር',
      'delete': 'ሰርዝ',
      'edit': 'አርትዕ',
      'save': 'አስቀምጥ',
      'save_changes': 'ለውጦችን መዝግብ',
      'view': 'ይመልከቱ',
      'assign': 'መድብ',
      'required': 'ያስፈልጋል',
      'action_required': 'እርምጃ ያስፈልጋል',
      'confirm_deletion': 'አረጋግጥ',
      'deleted': 'ተሰርዟል',
      'search': 'ፈልግ',
      'clear': 'አጽዳ',
      'none_unassigned': 'ምንም (ያልተመደበ)',
      'select': 'ይምረጡ',
      'dashboard': 'ዳሽቦርድ',
      'live_updates': 'አሁናዊ መረጃ',
      'search_actions': 'ተግባራትን ይፈልጉ...',
      'search_actions_pages': 'ተግባራትን ወይም ገጾችን ይፈልጉ...',
      'profile_settings': 'የመገለጫ ቅንብሮች',
      'my_profile': 'ስለ እኔ',
      'light_mode': 'ብሩህ ገጽታ',
      'dark_mode': 'ጨለማ ገጽታ',
      'logout': 'ውጣ',
      'select_church': 'ቤተክርስቲያን ይምረጡ',
      'no_results_found': 'ምንም ውጤቶች አልተገኙም።',
      'error_searching': 'በመፈለግ ላይ ስህተት ተፈጥሯል።',
      'welcome_back': 'እንኳን በደህና መጡ',
      'sign_in_prompt': 'ወደ መለያዎ ይግቡ',
      'username_or_email': 'ተጠቃሚ ስም ወይም ኢሜይል',
      'password_required': 'የይለፍ ቃል ያስፈልጋል',
      'remember_me': 'አስታውሰኝ',
      'forgot_password': 'የይለፍ ቃል ረሱ?',
      'sign_in': 'ይግቡ',
      'need_help': 'እርዳታ ይፈልጋሉ?',
      'contact_admin': 'ወደ ቤተክርስቲያን ለመመደብ እባክዎ ዋና አስተዳዳሪዎችን ያነጋግሩ።',
      'welcome_to_ministry': 'እንኳን ወደ ሚኒስትሪ ፖርታል በደህና መጡ',
      'nav_dashboard': 'የኢትዮጵያ ገነት ቤተክርስቲያን',
      'nav_church_admin': 'የቤተክርስቲያን አስተዳደር',
      'nav_churches': 'አጥቢያ ቤተክርስቲያናት',
      'nav_pastors': 'ፓስተሮች',
      'nav_departments': 'ዘርፎች',
      'nav_servants': 'አገልጋዮች',
      'nav_members': 'አባላት',
      'nav_add_member': 'አባል ጨምር',
      'nav_show_members': 'የአባላት ዝርዝር',
      'nav_analytics': 'ትንታኔዎች',
      'nav_settings': 'ማስተካከያዎች',
      'church_management': 'የቤተክርስቲያን አስተዳደር',
      'assign_to_enable': '(እንዲሰራ ለማድረግ ወደ ቤተክርስቲያን ይመደቡ)',
      'must_be_assigned': 'ይህንን ለማድረግ ወደ ቤተክርስቲያን መመደብ አለብዎት።',
      'action_disabled': 'ተቋርጧል',
      'welcome_message': 'ወደ ገነት ቤተክርስቲያን ፖርታል እንኳን በደህና መጡ!',
      'good_morning': 'እንደምን አደሩ',
      'good_afternoon': 'እንደምን ዋሉ',
      'good_evening': 'እንደምን አመሹ',
      'happening_today': 'ዛሬ በቤተክርስቲያንዎ ውስጥ ያለው ክንውን።',
      'timeframe_7d': 'የ 7 ቀናት',
      'timeframe_30d': 'የ 30 ቀናት',
      'timeframe_1y': 'የ 1 ዓመት',
      'timeframe_all': 'ጠቅላላ',
      'quick_stats': 'ፈጣን ስታቲስቲክስ',
      'view_full_report': 'ሙሉ ሪፖርት ይመልከቱ',
      'donations': 'መዋጮዎች',
      'coming_soon': 'በቅርብ ቀን',
      'no_celebration': 'ምንም በዓል የለም',
      'could_not_load_analytics': 'ትንታኔዎችን መጫን አልተቻለም',
      'total_churches': 'ጠቅላላ ቤተክርስቲያናት',
      'total_pastors': 'ጠቅላላ ፓስተሮች',
      'total_members': 'ጠቅላላ አባላት',
      'total_servants': 'ጠቅላላ አገልጋዮች',
      'churches_assigned': 'የተመደቡ ቤተ-ክርስቲያናት',
      'your_members': 'የቤተክርስቲያንዎ አባላት',
      'your_servants': 'የቤተክርስቲያንዎ አገልጋዮች',
      'your_departments': 'የቤተክርስቲያንዎ ዘርፎች',
      'recent_activity': 'የቅርብ ጊዜ እንቅስቃሴ',
      'latest_updates': 'የቅርብ ጊዜ ዝመናዎች እና ለውጦች',
      'activity_log': 'የእንቅስቃሴ ምዝግብ ማስታወሻ',
      'activity_log_desc':
      'በስርዓቱ ውስጥ ያሉ ሁሉም ዋና ዋና ክስተቶች እና ለውጦች የጊዜ ቅደም ተከተል ዝርዝር።',
      'no_activities_yet': 'እስካሁን ምንም እንቅስቃሴዎች የሉም',
      'no_activities_desc': 'በስርዓቱ ውስጥ እርምጃዎች ሲከናወኑ የእንቅስቃሴ ምዝግብ ማስታወሻዎች እዚህ ይታያሉ።',
      'failed_load_activities': 'እንቅስቃሴዎችን መጫን አልተሳካም',
      'church_records': 'አጥቢያ ቤተክርስቲያናት',
      'manage_churches_desc': 'ጠቅላላ አጥቢያዎችን ማስተዳደሪያ',
      'add_church': 'ቤተክርስቲያን ጨምር',
      'search_church_hint': 'በቤተክርስቲያን ስም ይፈልጉ...',
      'no_churches_match': 'ከፍለጋዎ ጋር የሚዛመዱ አጥቢያ ቤተክርስቲያናት የሉም',
      'no_churches_found': 'ምንም አጥቢያ ቤተክርስቲያናት አልተገኙም',
      'adjust_search_terms': 'ቃላትዎን ለማስተካከል ይሞክሩ።',
      'add_first_church_desc': 'ለመጀመር የመጀመሪያውን ቤተክርስቲያን ይመዝግቡ።',
      'add_first_church': 'የመጀመሪያ ቤተክርስቲያን መዝግብ',
      'new_church_details': 'የ አዳዲስ የቤተክርስቲያናት ዝርዝሮች',
      'new_church_desc': 'አዲስ የቤተክርስቲያን ቅርንጫፍ ወደ ዳታቤዙ ይጨምሩ።',
      'save_church': 'ቤተክርስቲያን መዝግብ',
      'church_name': 'የቤተክርስቲያኒቱ ስም',
      'church_name_empty': 'የቤተክርስቲያኒቱ ስም ባዶ መሆን የለበትም',
      'church_name_required': 'የቤተክርስቲያን ስም ያስፈልጋል።',
      'google_maps_link': 'የጉግል ካርታዎች ሊንክ (አማራጭ)',
      'establishment_date_optional': 'የተመሰረተበት ቀን (አማራጭ)',
      'church_establishment_date': 'የተመሰረተበት ቀን',
      'clear_form': 'ቅጹን አጽዳ',
      'church_added': 'የቤተክርስቲያኒቱ መረጃ በተሳካ ሁኔታ ወደ ዳታቤዙ ተጨምሯል',
      'failed_add_church': 'የቤተክርስቲያኒቱን መረጃ መጨመር አልተቻለም። እባክዎ እንደገና ይሞክሩ።',
      'invalid_form': 'የማይሰራ ቅጽ',
      'correct_errors': 'እባክዎ በቅጹ ላይ ያሉትን ስህተቶች ያስተካክሉ።',
      'view_on_map': 'በማፕ ላይ ይመልከቱ',
      'head_office_id': 'የዋና መስሪያ ቤት መታወቂያ',
      'est': 'የተመሰረተበት ጊዜ',
      'edit_church': 'የቤተክርስቲያን መረጃ አቀናብር',
      'church_updated': 'የቤተክርስቲያን መረጃ ተቀናብሯል!',
      'church_update_success': 'በ"{name}" ላይ የተደረጉ ለውጦች በተሳካ ሁኔታ ተቀምጠዋል።',
      'church_deleted': 'ቤተክርስቲያን ጠፍቷል',
      'church_delete_success': '"{name}" በተሳካ ሁኔታ ከዳታቤዙ ተወግዷል።',
      'failed_delete_church': 'ቤተክርስቲያን መሰረዝ አልተቻለም። እባክዎ እንደገና ይሞክሩ።',
      'has_location': 'ማፕ አለው',
      'sort_by': 'በ... ደርድር',
      'name_asc': 'ስም (A-Z)',
      'name_desc': 'ስም (Z-A)',
      'newest_first': 'አዳዲሶቹን መጀመሪያ',
      'oldest_first': 'የቆዩትን መጀመሪያ',
      'pastor_records': 'የፓስተሮች መዝገብ',
      'manage_pastors_desc': 'ፓስተሮችን ያስተዳድሩ',
      'add_new_pastor': 'አዲስ ፓስተር አክል',
      'search_pastor_hint': 'በስም ወይም በኢሜል ይፈልጉ...',
      'no_pastors_match': 'የሚዛመዱ ፓስተሮች የሉም',
      'no_pastors_found': 'ምንም ፓስተሮች አልተገኙም',
      'add_first_pastor_desc': 'የመጀመሪያውን ፓስተር ያክሉ።',
      'add_first_pastor': 'የመጀመሪያ ፓስተር አክል',
      'confirm_pastor_deletion': 'ፓስተር {name}ን መሰረዝ ይፈልጋሉ?',
      'pastor_deleted': '{name} ተሰርዟል።',
      'failed_delete_pastor': 'ፓስተርን መሰረዝ አልተቻለም።',
      'failed_delete_pastor_server': 'የአገልጋይ ስህተት፡ መሰረዝ አልተቻለም።',
      'assign_church_to': 'ቤተክርስቲያን ለ{name} መድብ',
      'unassign_church': 'ከቤተክርስቲያን ምደባ አንሳ',
      'unassigned_success': 'በተሳካ ሁኔታ ከምደባ ተነስቷል',
      'pastor_removed_church': 'ፓስተሩ ከቤተክርስቲያኑ ተወግዷል።',
      'failed_unassign': 'ከምደባ ማንሳት አልተቻለም',
      'church_assigned': 'ቤተክርስቲያን ተመድቧል።',
      'edit_pastor': 'ፓስተር አርትዕ',
      'pastor_updated_success': 'የፓስተር ዝርዝሮች ተዘምነዋል።',
      'failed_update': 'ማዘመን አልተቻለም።',
      'pastor_added': 'ፓስተር ታክሏል',
      'pastor_added_success': '{name} በተሳካ ሁኔታ ታክሏል።',
      'failed_add_pastor':
      'ፓሰተርን ማከል አልተቻለም። እባክዎ ዝርዝሮቹን ያረጋግጡ እና እንደገና ይሞክሩ።',
      'add_pastor': 'ፓሰተር ጨምር',
      'full_name': 'ሙሉ ስም',
      'email': 'ኢሜይል',
      'temporary_password': 'ጊዜያዊ የይለፍ ቃል',
      'min_6_chars': 'ቢያንስ 6 ቁምፊዎች',
      'assign_church_optional': 'ወደ ቤተክርስቲያን መድብ (አማራጭ)',
      'could_not_load_churches': 'አብያተ ክርስቲያናትን መጫን አልተቻለም',
      'new_pastor_details': 'አዲስ የፓሰተር ዝርዝሮች',
      'new_pastor_desc':
      'ለአዲሱ ፓሰተር መረጃውን ያስገቡ። መገለጫቸውን እንዲያጠናቅቁ ወደ ኢሜል ግብዣ ይላክላቸዋል።',
      'pastor_full_name': 'የፓሰተር ሙሉ ስም',
      'name_empty': 'ስም ባዶ መሆን አይችልም',
      'password_min_6': 'የይለፍ ቃል ቢያንስ 6 ቁልፎች መሆን አለባቸው',
      'pastor_added_message': 'እንደ ፓሰተር ታክለዋል።',
      'department_records': 'የዘርፎች መዝገብ',
      'manage_departments_desc': 'ዘርፎችን ያስተዳድሩ።',
      'add_new_department': 'አዲስ ዘርፍ ጨምር',
      'select_church_manage_departments': 'ዘርፎችን ለማስተዳደር ቤተክርስቲያን ይምረጡ።',
      'search_department_hint': 'በዘርፍ ስም ይፈልጉ...',
      'no_departments_match': 'የሚዛመዱ ዘርፎች የሉም',
      'no_departments_found': 'ምንም ዘርፎች አልተገኙም',
      'add_first_department_desc': 'የመጀመሪያውን ዘርፍ ይጨምሩ።',
      'no_departments_yet': 'ምንም ዘርፎች የሉም።',
      'add_first_department': 'የመጀመሪያ ዘርፍ ጨምር',
      'department_name': 'የዘርፉ ስም',
      'department': 'ዘርፍ',
      'add_department': 'ዘርፍ ጨምር',
      'department_added_success': '"{name}" ታክሏል።',
      'department_updated_success': 'ዘርፉ ዘምኗል።',
      'confirm_department_deletion': '"{name}"ን መሰረዝ ይፈልጋሉ?',
      'department_removed': '"{name}" ተወግዷል።',
      'failed_delete_department': 'መሰረዝ አልተቻለም።',
      'edit_department': '"{name}"ን አርትዕ',
      'active': 'ያልታገደ',
      'servants_count': '{count} አገልጋዮች',
      'select_church_first': 'እባክዎ መጀመሪያ ቤተክርስቲያን ይምረጡ።',
      'servant_records': 'የአገልጋዮች መዝገብ',
      'manage_servants_desc': 'አገልጋዮች ያስተዳድሩ።',
      'add_new_servant': 'አዲስ አገልጋይ አክል',
      'select_church_add_servant': 'አገልጋይ ለመጨመር ቤተክርስቲያን ይምረጡ።',
      'select_church_manage_servants': 'አገልጋዮችን ለማስተዳደር ቤተክርስቲያን ይምረጡ።',
      'search_servant_hint': 'በስም ወይም በኢሜል ይፈልጉ...',
      'no_servants_match': 'የሚዛመዱ አገልጋዮች የሉም',
      'no_servants_found': 'ምንም አገልጋዮች አልተገኙም',
      'add_first_servant_desc': 'የመጀመሪያውን አገልጋይ ያክሉ።',
      'no_servants_yet': 'ምንም አገልጋዮች የሉም።',
      'add_first_servant': 'የመጀመሪያ አገልጋይ አክል',
      'assign_department': 'ዘርፍ መድብ',
      'select_department': 'ዘርፍ ይምረጡ',
      'department_assigned': 'ዘርፍ ተመድቧል።',
      'failed_assign_department': 'ዘርፍ መመደብ አልተቻለም።',
      'edit_servant': 'አገልጋይ አርትዕ',
      'new_full_name': 'አዲስ ሙሉ ስም',
      'servant_updated_success': 'የአገልጋይ መረጃ ተዘምኗል።',
      'failed_update_servant': 'ማዘመን አልተቻለም።',
      'confirm_servant_deletion': 'አገልጋይ "{name}"ን መሰረዝ ይፈልጋሉ?',
      'servant_removed': 'አገልጋይ "{name}" ተወግዷል።',
      'failed_remove_servant': 'ማስወገድ አልተቻለም።',
      'add_servant': 'አገልጋይ አክል',
      'servant_added_success': 'አገልጋይ "{name}" ታክሏል።',
      'failed_add_servant': 'አገልጋይ ማከል አልተቻለም።',
      'could_not_load_departments': 'ዘርፎችን መጫን አልተቻለም።',
      'member_records': 'የአባላት መረጃዎች',
      'member_records_desc':
      'በቤተክርስቲያኑ ውስጥ የተመዘገቡ ሁሉንም አባላት የሚፈልግ እና የሚያጣራ ዝርዝር።',
      'addNewMember': 'አዲስ አባል ጨምር',
      'add_new_member': 'አዲስ አባል ጨምር',
      'select_church_hint': 'አባላትን ለማየት እባክዎ ከራስጌው ላይ ቤተክርስቲያን ይምረጡ።',
      'search_member_hint': 'በስም ወይም በስልክ ቁጥር ይፈልጉ...',
      'no_members_match': 'ከማጣሪያዎችዎ ጋር የሚዛመዱ አባላት የሉም',
      'no_members_found': 'ምንም አባላት አልተገኙም',
      'adjust_filter_criteria': 'የፍለጋ ወይም የማጣሪያ መስፈርቶችዎን ለማስተካከል ይሞክሩ።',
      'add_first_member_desc': 'ለመጀመር የመጀመሪያውን አባል ይመዝግቡ።',
      'no_members_registered': 'ለዚህ ቤተክርስቲያን እስካሁን ምንም አባላት አልተመዘገቡም።',
      'add_first_member': 'የመጀመሪያ አባል አክል',
      'confirm_member_deletion':
      'እርግጠኛ ነዎት "{name}"ን መሰረዝ ይፈልጋሉ? ይህ እርምጃ ሊስተካከል አይችልም።',
      'member_deleted_success': 'አባሉ በተሳካ ሁኔታ ተሰርዟል።',
      'delete_member_failed': 'አባሉን መሰረዝ አልተሳካም።',
      'personal_information': 'የግል መረጃ',
      'phone': 'ስልክ',
      'birth_date': 'የትውልድ ቀን',
      'birth_place': 'የትውልድ ቦታ',
      'membership_details': 'የአባልነት ዝርዝሮች',
      'status': 'ሁኔታ',
      'status_changed': 'ሁኔታ ተቀይሯል',
      'baptized_date': 'የተጠመቀበት ቀን',
      'address': 'አድራሻ',
      'city_sub_city': 'ከተማ / ክፍለ ከተማ',
      'woreda': 'ወረዳ',
      'place_name': 'የቦታ ስም',
      'gender': 'ጾታ',
      'male': 'ወንድ',
      'female': 'ሴት',
      'new_believer': 'አዲስ አማኝ',
      'inactive': 'የታገደ',
      'personal_info': 'የግል መረጃ',
      'basic_details': 'መሰረታዊ ዝርዝሮች',
      'location_details': 'የአካባቢ ዝርዝሮች',
      'additional_info': 'ተጨማሪ',
      'church_info': 'የቤተክርስቲያን መረጃ',
      'incomplete_form': 'ያልተሟላ ቅጽ',
      'complete_all_fields': 'እባክዎ በሁሉም ገጾች ላይ ያሉትን ሁሉንም አስፈላጊ መስኮች ይሙሉ',
      'church_required': 'ቤተክርስቲያን ያስፈልጋል',
      'select_church_before_adding': 'አባል ከመጨመርዎ በፊት እባክዎ ቤተክርስቲያን ይምረጡ።',
      'provide_born_again_date': 'እባክዎ አባሉ ዳግም የተወለደበትን ቀን ያቅርቡ።',
      'member_added_success': 'አባሉ በተሳካ ሁኔታ ወደ ዳታቤዙ ታክሏል።',
      'failed_add_member': 'አባል ማከል አልተቻለም',
      'register_new_member': 'አዲስ አባል ይመዝገቡ',
      'fill_details_add_member': 'አዲስ የቤተክርስቲያን አባል ለመጨመር ዝርዝሮቹን ይሙሉ',
      'previous_step': 'ቀዳሚ',
      'continue_step': 'ቀጥል',
      'save_member': 'አባል አስቀምጥ',
      'phone_number': 'ስልክ ቁጥር',
      'mother_tongue': 'የአፍ መፍቻ ቋንቋ',
      'city': 'ከተማ',
      'sub_city': 'ክፍለ ከተማ',
      'specific_place_name': 'ልዩ የቦታ ስም',
      'education_level': 'የትምህርት ደረጃ',
      'job_status': 'የስራ ሁኔታ',
      'marriage_status': 'የጋብቻ ሁኔታ',
      'income_range': 'የገቢ መጠን',
      'baptism_status': 'የጥምቀት ሁኔታ',
      'born_again_date': 'ዳግም የተወለደበት ቀን',
      'baptism_date': 'የጥምቀት ቀን',
      'baptism_date_required': 'የጥምቀት ቀን ያስፈልጋል',
      'phone_numbers_only': 'ስልክ ቁጥሮች ብቻ መያዝ አለበት',
      'select_date': 'እባክዎ ቀን ይምረጡ',
      'required_field': 'ያስፈልጋል',
      'analytics_dashboard': 'የትንታኔ ዳሽቦርድ',
      'analytics_desc': 'ጠቅላላ ትንታኔዎች',
      'updated_just_now': 'አሁን ዘምኗል',
      'live_data': 'አሁናዊ መረጃዎች',
      'export_report': 'ሪፖርት ላክ',
      'loading_analytics': 'ትንታኔዎችን በመጫን ላይ...',
      'failed_load_analytics': 'ውሂብ መጫን አልተቻለም',
      'member_gender_dist': 'የአባላት ጾታ ስርጭት',
      'total_label': 'ጠቅላላ: {count}',
      'member_status': 'የአባላት ሁኔታ',
      'no_data_available': 'ምንም ውሂብ የለም።',
      'members_label': 'አባላት',
      'validation_error': 'የማረጋገጫ ስህተት',
      'delete_confirmation':
      'እርግጠኛ ነዎት "{name}"ን መሰረዝ ይፈልጋሉ? ይህ እርምጃ ሊመለስ አይችልም።',
      'delete_failed': 'አልተሳካም',
      'add_failed': 'መጨመር አልተሳካም',
      'update_failed': 'ማዘመን አልተሳካም',
    },
  };

  String get settings => _localizedValues[locale.languageCode]!['settings']!;
  String get customizeExperience =>
      _localizedValues[locale.languageCode]!['customize_experience']!;
  String get powerUser => _localizedValues[locale.languageCode]!['power_user']!;
  String get globalCommandPalette =>
      _localizedValues[locale.languageCode]!['global_command_palette']!;
  String get commandPaletteDesc =>
      _localizedValues[locale.languageCode]!['command_palette_desc']!;
  String get appearance =>
      _localizedValues[locale.languageCode]!['appearance']!;
  String get themeMode => _localizedValues[locale.languageCode]!['theme_mode']!;
  String get chooseVisualPreference =>
      _localizedValues[locale.languageCode]!['choose_visual_preference']!;
  String get light => _localizedValues[locale.languageCode]!['light']!;
  String get dark => _localizedValues[locale.languageCode]!['dark']!;
  String get system => _localizedValues[locale.languageCode]!['system']!;
  String get localization =>
      _localizedValues[locale.languageCode]!['localization']!;
  String get language => _localizedValues[locale.languageCode]!['language']!;
  String get selectLanguage =>
      _localizedValues[locale.languageCode]!['select_language']!;
  String get dateFormat =>
      _localizedValues[locale.languageCode]!['date_format']!;
  String get chooseCalendarFormat =>
      _localizedValues[locale.languageCode]!['choose_calendar_format']!;
  String get gregorian => _localizedValues[locale.languageCode]!['gregorian']!;
  String get ethiopian => _localizedValues[locale.languageCode]!['ethiopian']!;
  String get about => _localizedValues[locale.languageCode]!['about']!;
  String get version => _localizedValues[locale.languageCode]!['version']!;
  String get latest => _localizedValues[locale.languageCode]!['latest']!;
  String get success => _localizedValues[locale.languageCode]!['success']!;
  String get error => _localizedValues[locale.languageCode]!['error']!;
  String get cancel => _localizedValues[locale.languageCode]!['cancel']!;
  String get delete => _localizedValues[locale.languageCode]!['delete']!;
  String get edit => _localizedValues[locale.languageCode]!['edit']!;
  String get save => _localizedValues[locale.languageCode]!['save']!;
  String get saveChanges =>
      _localizedValues[locale.languageCode]!['save_changes']!;
  String get view => _localizedValues[locale.languageCode]!['view']!;
  String get assign => _localizedValues[locale.languageCode]!['assign']!;
  String get required => _localizedValues[locale.languageCode]!['required']!;
  String get actionRequired =>
      _localizedValues[locale.languageCode]!['action_required']!;
  String get confirmDeletion =>
      _localizedValues[locale.languageCode]!['confirm_deletion']!;
  String get deleted => _localizedValues[locale.languageCode]!['deleted']!;
  String get search => _localizedValues[locale.languageCode]!['search']!;
  String get clear => _localizedValues[locale.languageCode]!['clear']!;
  String get noneUnassigned =>
      _localizedValues[locale.languageCode]!['none_unassigned']!;
  String get select => _localizedValues[locale.languageCode]!['select']!;
  String get dashboard => _localizedValues[locale.languageCode]!['dashboard']!;
  String get liveUpdates =>
      _localizedValues[locale.languageCode]!['live_updates']!;
  String get searchActions =>
      _localizedValues[locale.languageCode]!['search_actions']!;
  String get searchActionsOrPages =>
      _localizedValues[locale.languageCode]!['search_actions_pages']!;
  String get profileSettings =>
      _localizedValues[locale.languageCode]!['profile_settings']!;
  String get myProfile => _localizedValues[locale.languageCode]!['my_profile']!;
  String get lightMode => _localizedValues[locale.languageCode]!['light_mode']!;
  String get darkMode => _localizedValues[locale.languageCode]!['dark_mode']!;
  String get logout => _localizedValues[locale.languageCode]!['logout']!;
  String get selectChurch =>
      _localizedValues[locale.languageCode]!['select_church']!;
  String get noResultsFound =>
      _localizedValues[locale.languageCode]!['no_results_found']!;
  String get errorSearching =>
      _localizedValues[locale.languageCode]!['error_searching']!;
  String get welcomeBack =>
      _localizedValues[locale.languageCode]!['welcome_back']!;
  String get signInPrompt =>
      _localizedValues[locale.languageCode]!['sign_in_prompt']!;
  String get usernameOrEmail =>
      _localizedValues[locale.languageCode]!['username_or_email']!;
  String get passwordRequired =>
      _localizedValues[locale.languageCode]!['password_required']!;
  String get rememberMe =>
      _localizedValues[locale.languageCode]!['remember_me']!;
  String get forgotPassword =>
      _localizedValues[locale.languageCode]!['forgot_password']!;
  String get signIn => _localizedValues[locale.languageCode]!['sign_in']!;
  String get needHelp => _localizedValues[locale.languageCode]!['need_help']!;
  String get contactAdmin =>
      _localizedValues[locale.languageCode]!['contact_admin']!;
  String get welcomeToMinistry =>
      _localizedValues[locale.languageCode]!['welcome_to_ministry']!;
  String get navDashboard =>
      _localizedValues[locale.languageCode]!['nav_dashboard']!;
  String get navChurchAdmin =>
      _localizedValues[locale.languageCode]!['nav_church_admin']!;
  String get navChurches =>
      _localizedValues[locale.languageCode]!['nav_churches']!;
  String get navPastors =>
      _localizedValues[locale.languageCode]!['nav_pastors']!;
  String get navDepartments =>
      _localizedValues[locale.languageCode]!['nav_departments']!;
  String get navServants =>
      _localizedValues[locale.languageCode]!['nav_servants']!;
  String get navMembers =>
      _localizedValues[locale.languageCode]!['nav_members']!;
  String get navAddMember =>
      _localizedValues[locale.languageCode]!['nav_add_member']!;
  String get navShowMembers =>
      _localizedValues[locale.languageCode]!['nav_show_members']!;
  String get navAnalytics =>
      _localizedValues[locale.languageCode]!['nav_analytics']!;
  String get navSettings =>
      _localizedValues[locale.languageCode]!['nav_settings']!;
  String get churchManagement =>
      _localizedValues[locale.languageCode]!['church_management']!;
  String get assignToEnable =>
      _localizedValues[locale.languageCode]!['assign_to_enable']!;
  String get mustBeAssigned =>
      _localizedValues[locale.languageCode]!['must_be_assigned']!;
  String get actionDisabled =>
      _localizedValues[locale.languageCode]!['action_disabled']!;
  String get welcomeMessage =>
      _localizedValues[locale.languageCode]!['welcome_message']!;
  String get goodMorning =>
      _localizedValues[locale.languageCode]!['good_morning']!;
  String get goodAfternoon =>
      _localizedValues[locale.languageCode]!['good_afternoon']!;
  String get goodEvening =>
      _localizedValues[locale.languageCode]!['good_evening']!;
  String get happeningToday =>
      _localizedValues[locale.languageCode]!['happening_today']!;
  String get timeframe7d =>
      _localizedValues[locale.languageCode]!['timeframe_7d']!;
  String get timeframe30d =>
      _localizedValues[locale.languageCode]!['timeframe_30d']!;
  String get timeframe1y =>
      _localizedValues[locale.languageCode]!['timeframe_1y']!;
  String get timeframeAll =>
      _localizedValues[locale.languageCode]!['timeframe_all']!;
  String get quickStats =>
      _localizedValues[locale.languageCode]!['quick_stats']!;
  String get viewFullReport =>
      _localizedValues[locale.languageCode]!['view_full_report']!;
  String get donations => _localizedValues[locale.languageCode]!['donations']!;
  String get comingSoon =>
      _localizedValues[locale.languageCode]!['coming_soon']!;
  String get noCelebration =>
      _localizedValues[locale.languageCode]!['no_celebration']!;
  String get couldNotLoadAnalytics =>
      _localizedValues[locale.languageCode]!['could_not_load_analytics']!;
  String get totalChurches =>
      _localizedValues[locale.languageCode]!['total_churches']!;
  String get totalPastors =>
      _localizedValues[locale.languageCode]!['total_pastors']!;
  String get totalMembers =>
      _localizedValues[locale.languageCode]!['total_members']!;
  String get totalServants =>
      _localizedValues[locale.languageCode]!['total_servants']!;
  String get churchesAssigned =>
      _localizedValues[locale.languageCode]!['churches_assigned']!;
  String get yourMembers =>
      _localizedValues[locale.languageCode]!['your_members']!;
  String get yourServants =>
      _localizedValues[locale.languageCode]!['your_servants']!;
  String get yourDepartments =>
      _localizedValues[locale.languageCode]!['your_departments']!;
  String get recentActivity =>
      _localizedValues[locale.languageCode]!['recent_activity']!;
  String get latestUpdates =>
      _localizedValues[locale.languageCode]!['latest_updates']!;
  String get activityLog =>
      _localizedValues[locale.languageCode]!['activity_log']!;
  String get activityLogDesc =>
      _localizedValues[locale.languageCode]!['activity_log_desc']!;
  String get noActivitiesYet =>
      _localizedValues[locale.languageCode]!['no_activities_yet']!;
  String get noActivitiesDesc =>
      _localizedValues[locale.languageCode]!['no_activities_desc']!;
  String get failedLoadActivities =>
      _localizedValues[locale.languageCode]!['failed_load_activities']!;
  String get churchRecords =>
      _localizedValues[locale.languageCode]!['church_records']!;
  String get manageChurchesDesc =>
      _localizedValues[locale.languageCode]!['manage_churches_desc']!;
  String get addChurch => _localizedValues[locale.languageCode]!['add_church']!;
  String get searchChurchHint =>
      _localizedValues[locale.languageCode]!['search_church_hint']!;
  String get noChurchesMatch =>
      _localizedValues[locale.languageCode]!['no_churches_match']!;
  String get noChurchesFound =>
      _localizedValues[locale.languageCode]!['no_churches_found']!;
  String get adjustSearchTerms =>
      _localizedValues[locale.languageCode]!['adjust_search_terms']!;
  String get addFirstChurchDesc =>
      _localizedValues[locale.languageCode]!['add_first_church_desc']!;
  String get addFirstChurch =>
      _localizedValues[locale.languageCode]!['add_first_church']!;
  String get newChurchDetails =>
      _localizedValues[locale.languageCode]!['new_church_details']!;
  String get newChurchDesc =>
      _localizedValues[locale.languageCode]!['new_church_desc']!;
  String get saveChurch =>
      _localizedValues[locale.languageCode]!['save_church']!;
  String get churchName =>
      _localizedValues[locale.languageCode]!['church_name']!;
  String get churchNameEmpty =>
      _localizedValues[locale.languageCode]!['church_name_empty']!;
  String get churchNameRequired =>
      _localizedValues[locale.languageCode]!['church_name_required']!;
  String get googleMapsLink =>
      _localizedValues[locale.languageCode]!['google_maps_link']!;
  String get establishmentDateOptional =>
      _localizedValues[locale.languageCode]!['establishment_date_optional']!;
  String get churchEstablishmentDate =>
      _localizedValues[locale.languageCode]!['church_establishment_date']!;
  String get clearForm => _localizedValues[locale.languageCode]!['clear_form']!;
  String get churchAdded =>
      _localizedValues[locale.languageCode]!['church_added']!;
  String get failedAddChurch =>
      _localizedValues[locale.languageCode]!['failed_add_church']!;
  String get invalidForm =>
      _localizedValues[locale.languageCode]!['invalid_form']!;
  String get correctErrors =>
      _localizedValues[locale.languageCode]!['correct_errors']!;
  String get viewOnMap =>
      _localizedValues[locale.languageCode]!['view_on_map']!;
  String get headOfficeId =>
      _localizedValues[locale.languageCode]!['head_office_id']!;
  String get est => _localizedValues[locale.languageCode]!['est']!;
  String get editChurch =>
      _localizedValues[locale.languageCode]!['edit_church']!;
  String get churchUpdated =>
      _localizedValues[locale.languageCode]!['church_updated']!;
  String get churchUpdateSuccess =>
      _localizedValues[locale.languageCode]!['church_update_success']!;
  String get churchDeleted =>
      _localizedValues[locale.languageCode]!['church_deleted']!;
  String get churchDeleteSuccess =>
      _localizedValues[locale.languageCode]!['church_delete_success']!;
  String get failedDeleteChurch =>
      _localizedValues[locale.languageCode]!['failed_delete_church']!;
  String get hasLocation =>
      _localizedValues[locale.languageCode]!['has_location']!;
  String get sortBy => _localizedValues[locale.languageCode]!['sort_by']!;
  String get nameAsc => _localizedValues[locale.languageCode]!['name_asc']!;
  String get nameDesc => _localizedValues[locale.languageCode]!['name_desc']!;
  String get newestFirst =>
      _localizedValues[locale.languageCode]!['newest_first']!;
  String get oldestFirst =>
      _localizedValues[locale.languageCode]!['oldest_first']!;
  String get pastorRecords =>
      _localizedValues[locale.languageCode]!['pastor_records']!;
  String get managePastorsDesc =>
      _localizedValues[locale.languageCode]!['manage_pastors_desc']!;
  String get addNewPastor =>
      _localizedValues[locale.languageCode]!['add_new_pastor']!;
  String get searchPastorHint =>
      _localizedValues[locale.languageCode]!['search_pastor_hint']!;
  String get noPastorsMatch =>
      _localizedValues[locale.languageCode]!['no_pastors_match']!;
  String get noPastorsFound =>
      _localizedValues[locale.languageCode]!['no_pastors_found']!;
  String get addFirstPastorDesc =>
      _localizedValues[locale.languageCode]!['add_first_pastor_desc']!;
  String get addFirstPastor =>
      _localizedValues[locale.languageCode]!['add_first_pastor']!;
  String get confirmPastorDeletion =>
      _localizedValues[locale.languageCode]!['confirm_pastor_deletion']!;
  String get pastorDeleted =>
      _localizedValues[locale.languageCode]!['pastor_deleted']!;
  String get failedDeletePastor =>
      _localizedValues[locale.languageCode]!['failed_delete_pastor']!;
  String get failedDeletePastorServer =>
      _localizedValues[locale.languageCode]!['failed_delete_pastor_server']!;
  String get assignChurchTo =>
      _localizedValues[locale.languageCode]!['assign_church_to']!;
  String get unassignChurch =>
      _localizedValues[locale.languageCode]!['unassign_church']!;
  String get unassignedSuccess =>
      _localizedValues[locale.languageCode]!['unassigned_success']!;
  String get pastorRemovedChurch =>
      _localizedValues[locale.languageCode]!['pastor_removed_church']!;
  String get failedUnassign =>
      _localizedValues[locale.languageCode]!['failed_unassign']!;
  String get churchAssigned =>
      _localizedValues[locale.languageCode]!['church_assigned']!;
  String get editPastor =>
      _localizedValues[locale.languageCode]!['edit_pastor']!;
  String get pastorUpdatedSuccess =>
      _localizedValues[locale.languageCode]!['pastor_updated_success']!;
  String get failedUpdate =>
      _localizedValues[locale.languageCode]!['failed_update']!;
  String get pastorAdded =>
      _localizedValues[locale.languageCode]!['pastor_added']!;
  String get pastorAddedSuccess =>
      _localizedValues[locale.languageCode]!['pastor_added_success']!;
  String get failedAddPastor =>
      _localizedValues[locale.languageCode]!['failed_add_pastor']!;
  String get addPastor => _localizedValues[locale.languageCode]!['add_pastor']!;
  String get fullName => _localizedValues[locale.languageCode]!['full_name']!;
  String get email => _localizedValues[locale.languageCode]!['email']!;
  String get temporaryPassword =>
      _localizedValues[locale.languageCode]!['temporary_password']!;
  String get min6Chars =>
      _localizedValues[locale.languageCode]!['min_6_chars']!;
  String get assignChurchOptional =>
      _localizedValues[locale.languageCode]!['assign_church_optional']!;
  String get couldNotLoadChurches =>
      _localizedValues[locale.languageCode]!['could_not_load_churches']!;
  String get newPastorDetails =>
      _localizedValues[locale.languageCode]!['new_pastor_details']!;
  String get newPastorDesc =>
      _localizedValues[locale.languageCode]!['new_pastor_desc']!;
  String get pastorFullName =>
      _localizedValues[locale.languageCode]!['pastor_full_name']!;
  String get nameEmpty => _localizedValues[locale.languageCode]!['name_empty']!;
  String get passwordMin6 =>
      _localizedValues[locale.languageCode]!['password_min_6']!;
  String get pastorAddedMessage =>
      _localizedValues[locale.languageCode]!['pastor_added_message']!;
  String get departmentRecords =>
      _localizedValues[locale.languageCode]!['department_records']!;
  String get manageDepartmentsDesc =>
      _localizedValues[locale.languageCode]!['manage_departments_desc']!;
  String get addNewDepartment =>
      _localizedValues[locale.languageCode]!['add_new_department']!;
  String get selectChurchManageDepartments =>
      _localizedValues[locale
          .languageCode]!['select_church_manage_departments']!;
  String get searchDepartmentHint =>
      _localizedValues[locale.languageCode]!['search_department_hint']!;
  String get noDepartmentsMatch =>
      _localizedValues[locale.languageCode]!['no_departments_match']!;
  String get noDepartmentsFound =>
      _localizedValues[locale.languageCode]!['no_departments_found']!;
  String get addFirstDepartmentDesc =>
      _localizedValues[locale.languageCode]!['add_first_department_desc']!;
  String get noDepartmentsYet =>
      _localizedValues[locale.languageCode]!['no_departments_yet']!;
  String get addFirstDepartment =>
      _localizedValues[locale.languageCode]!['add_first_department']!;
  String get departmentName =>
      _localizedValues[locale.languageCode]!['department_name']!;
  String get department =>
      _localizedValues[locale.languageCode]!['department']!;
  String get addDepartment =>
      _localizedValues[locale.languageCode]!['add_department']!;
  String get departmentAddedSuccess =>
      _localizedValues[locale.languageCode]!['department_added_success']!;
  String get departmentUpdatedSuccess =>
      _localizedValues[locale.languageCode]!['department_updated_success']!;
  String get confirmDepartmentDeletion =>
      _localizedValues[locale.languageCode]!['confirm_department_deletion']!;
  String get departmentRemoved =>
      _localizedValues[locale.languageCode]!['department_removed']!;
  String get failedDeleteDepartment =>
      _localizedValues[locale.languageCode]!['failed_delete_department']!;
  String get editDepartment =>
      _localizedValues[locale.languageCode]!['edit_department']!;
  String get active => _localizedValues[locale.languageCode]!['active']!;
  String get servantsCount =>
      _localizedValues[locale.languageCode]!['servants_count']!;
  String get selectChurchFirst =>
      _localizedValues[locale.languageCode]!['select_church_first']!;
  String get servantRecords =>
      _localizedValues[locale.languageCode]!['servant_records']!;
  String get manageServantsDesc =>
      _localizedValues[locale.languageCode]!['manage_servants_desc']!;
  String get addNewServant =>
      _localizedValues[locale.languageCode]!['add_new_servant']!;
  String get selectChurchAddServant =>
      _localizedValues[locale.languageCode]!['select_church_add_servant']!;
  String get selectChurchManageServants =>
      _localizedValues[locale.languageCode]!['select_church_manage_servants']!;
  String get searchServantHint =>
      _localizedValues[locale.languageCode]!['search_servant_hint']!;
  String get noServantsMatch =>
      _localizedValues[locale.languageCode]!['no_servants_match']!;
  String get noServantsFound =>
      _localizedValues[locale.languageCode]!['no_servants_found']!;
  String get addFirstServantDesc =>
      _localizedValues[locale.languageCode]!['add_first_servant_desc']!;
  String get noServantsYet =>
      _localizedValues[locale.languageCode]!['no_servants_yet']!;
  String get addFirstServant =>
      _localizedValues[locale.languageCode]!['add_first_servant']!;
  String get assignDepartment =>
      _localizedValues[locale.languageCode]!['assign_department']!;
  String get selectDepartment =>
      _localizedValues[locale.languageCode]!['select_department']!;
  String get departmentAssigned =>
      _localizedValues[locale.languageCode]!['department_assigned']!;
  String get failedAssignDepartment =>
      _localizedValues[locale.languageCode]!['failed_assign_department']!;
  String get editServant =>
      _localizedValues[locale.languageCode]!['edit_servant']!;
  String get newFullName =>
      _localizedValues[locale.languageCode]!['new_full_name']!;
  String get servantUpdatedSuccess =>
      _localizedValues[locale.languageCode]!['servant_updated_success']!;
  String get failedUpdateServant =>
      _localizedValues[locale.languageCode]!['failed_update_servant']!;
  String get confirmServantDeletion =>
      _localizedValues[locale.languageCode]!['confirm_servant_deletion']!;
  String get servantRemoved =>
      _localizedValues[locale.languageCode]!['servant_removed']!;
  String get failedRemoveServant =>
      _localizedValues[locale.languageCode]!['failed_remove_servant']!;
  String get addServant =>
      _localizedValues[locale.languageCode]!['add_servant']!;
  String get servantAddedSuccess =>
      _localizedValues[locale.languageCode]!['servant_added_success']!;
  String get failedAddServant =>
      _localizedValues[locale.languageCode]!['failed_add_servant']!;
  String get couldNotLoadDepartments =>
      _localizedValues[locale.languageCode]!['could_not_load_departments']!;
  String get memberRecords =>
      _localizedValues[locale.languageCode]!['member_records']!;
  String get memberRecordsDesc =>
      _localizedValues[locale.languageCode]!['member_records_desc']!;
  String get addNewMember =>
      _localizedValues[locale.languageCode]!['addNewMember']!;
  String get add_new_member =>
      _localizedValues[locale.languageCode]!['add_new_member']!;
  String get selectChurchHint =>
      _localizedValues[locale.languageCode]!['select_church_hint']!;
  String get searchMemberHint =>
      _localizedValues[locale.languageCode]!['search_member_hint']!;
  String get noMembersMatch =>
      _localizedValues[locale.languageCode]!['no_members_match']!;
  String get noMembersFound =>
      _localizedValues[locale.languageCode]!['no_members_found']!;
  String get adjustFilterCriteria =>
      _localizedValues[locale.languageCode]!['adjust_filter_criteria']!;
  String get addFirstMemberDesc =>
      _localizedValues[locale.languageCode]!['add_first_member_desc']!;
  String get noMembersRegistered =>
      _localizedValues[locale.languageCode]!['no_members_registered']!;
  String get addFirstMember =>
      _localizedValues[locale.languageCode]!['add_first_member']!;
  String get confirmMemberDeletion =>
      _localizedValues[locale.languageCode]!['confirm_member_deletion']!;
  String get memberDeletedSuccess =>
      _localizedValues[locale.languageCode]!['member_deleted_success']!;
  String get deleteMemberFailed =>
      _localizedValues[locale.languageCode]!['delete_member_failed']!;
  String get personalInformation =>
      _localizedValues[locale.languageCode]!['personal_information']!;
  String get phone => _localizedValues[locale.languageCode]!['phone']!;
  String get birthDate => _localizedValues[locale.languageCode]!['birth_date']!;
  String get birthPlace =>
      _localizedValues[locale.languageCode]!['birth_place']!;
  String get membershipDetails =>
      _localizedValues[locale.languageCode]!['membership_details']!;
  String get status => _localizedValues[locale.languageCode]!['status']!;
  String get statusChanged =>
      _localizedValues[locale.languageCode]!['status_changed']!;
  String get baptizedDate =>
      _localizedValues[locale.languageCode]!['baptized_date']!;
  String get address => _localizedValues[locale.languageCode]!['address']!;
  String get citySubCity =>
      _localizedValues[locale.languageCode]!['city_sub_city']!;
  String get woreda => _localizedValues[locale.languageCode]!['woreda']!;
  String get placeName => _localizedValues[locale.languageCode]!['place_name']!;
  String get gender => _localizedValues[locale.languageCode]!['gender']!;
  String get male => _localizedValues[locale.languageCode]!['male']!;
  String get female => _localizedValues[locale.languageCode]!['female']!;
  String get newBeliever =>
      _localizedValues[locale.languageCode]!['new_believer']!;
  String get inactive => _localizedValues[locale.languageCode]!['inactive']!;
  String get personalInfo =>
      _localizedValues[locale.languageCode]!['personal_info']!;
  String get basicDetails =>
      _localizedValues[locale.languageCode]!['basic_details']!;
  String get locationDetails =>
      _localizedValues[locale.languageCode]!['location_details']!;
  String get additionalInfo =>
      _localizedValues[locale.languageCode]!['additional_info']!;
  String get churchInfo =>
      _localizedValues[locale.languageCode]!['church_info']!;
  String get incompleteForm =>
      _localizedValues[locale.languageCode]!['incomplete_form']!;
  String get completeAllFields =>
      _localizedValues[locale.languageCode]!['complete_all_fields']!;
  String get churchRequired =>
      _localizedValues[locale.languageCode]!['church_required']!;
  String get selectChurchBeforeAdding =>
      _localizedValues[locale.languageCode]!['select_church_before_adding']!;
  String get provideBornAgainDate =>
      _localizedValues[locale.languageCode]!['provide_born_again_date']!;
  String get memberAddedSuccess =>
      _localizedValues[locale.languageCode]!['member_added_success']!;
  String get failedAddMember =>
      _localizedValues[locale.languageCode]!['failed_add_member']!;
  String get registerNewMember =>
      _localizedValues[locale.languageCode]!['register_new_member']!;
  String get fillDetailsAddMember =>
      _localizedValues[locale.languageCode]!['fill_details_add_member']!;
  String get previousStep =>
      _localizedValues[locale.languageCode]!['previous_step']!;
  String get continueStep =>
      _localizedValues[locale.languageCode]!['continue_step']!;
  String get saveMember =>
      _localizedValues[locale.languageCode]!['save_member']!;
  String get phoneNumber =>
      _localizedValues[locale.languageCode]!['phone_number']!;
  String get motherTongue =>
      _localizedValues[locale.languageCode]!['mother_tongue']!;
  String get city => _localizedValues[locale.languageCode]!['city']!;
  String get subCity => _localizedValues[locale.languageCode]!['sub_city']!;
  String get specificPlaceName =>
      _localizedValues[locale.languageCode]!['specific_place_name']!;
  String get educationLevel =>
      _localizedValues[locale.languageCode]!['education_level']!;
  String get jobStatus => _localizedValues[locale.languageCode]!['job_status']!;
  String get marriageStatus =>
      _localizedValues[locale.languageCode]!['marriage_status']!;
  String get incomeRange =>
      _localizedValues[locale.languageCode]!['income_range']!;
  String get baptismStatus =>
      _localizedValues[locale.languageCode]!['baptism_status']!;
  String get bornAgainDate =>
      _localizedValues[locale.languageCode]!['born_again_date']!;
  String get baptismDate =>
      _localizedValues[locale.languageCode]!['baptism_date']!;
  String get baptismDateRequired =>
      _localizedValues[locale.languageCode]!['baptism_date_required']!;
  String get phoneNumbersOnly =>
      _localizedValues[locale.languageCode]!['phone_numbers_only']!;
  String get selectDate =>
      _localizedValues[locale.languageCode]!['select_date']!;
  String get requiredField =>
      _localizedValues[locale.languageCode]!['required_field']!;
  String get analyticsDashboard =>
      _localizedValues[locale.languageCode]!['analytics_dashboard']!;
  String get analyticsDesc =>
      _localizedValues[locale.languageCode]!['analytics_desc']!;
  String get updatedJustNow =>
      _localizedValues[locale.languageCode]!['updated_just_now']!;
  String get liveData => _localizedValues[locale.languageCode]!['live_data']!;
  String get exportReport =>
      _localizedValues[locale.languageCode]!['export_report']!;
  String get loadingAnalytics =>
      _localizedValues[locale.languageCode]!['loading_analytics']!;
  String get failedLoadAnalytics =>
      _localizedValues[locale.languageCode]!['failed_load_analytics']!;
  String get memberGenderDist =>
      _localizedValues[locale.languageCode]!['member_gender_dist']!;
  String get totalLabel =>
      _localizedValues[locale.languageCode]!['total_label']!;
  String get memberStatus =>
      _localizedValues[locale.languageCode]!['member_status']!;
  String get noDataAvailable =>
      _localizedValues[locale.languageCode]!['no_data_available']!;
  String get membersLabel =>
      _localizedValues[locale.languageCode]!['members_label']!;
  String get validationError =>
      _localizedValues[locale.languageCode]!['validation_error']!;
  String get deleteConfirmation =>
      _localizedValues[locale.languageCode]!['delete_confirmation']!;
  String get deleteFailed =>
      _localizedValues[locale.languageCode]!['delete_failed']!;
  String get addFailed => _localizedValues[locale.languageCode]!['add_failed']!;
  String get updateFailed =>
      _localizedValues[locale.languageCode]!['update_failed']!;

  static AppLocalization of(BuildContext context) {
    return AppLocalization(const Locale('en'));
  }
}