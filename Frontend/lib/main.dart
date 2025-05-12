import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Screens
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/profile/profile_dashboard.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/feedback_grievance_screen.dart';
import 'screens/city_services_screen.dart';
import 'screens/report_missed_pickup_screen.dart';
import 'screens/bills_payment_screen.dart';
import 'screens/parking_dashboard.dart';
import 'screens/find_parking_screen.dart';
import 'screens/book_parking_screen.dart';
import 'screens/parking_history_screen.dart';
import 'screens/report_parking_issue_screen.dart';
import 'screens/citizen_engagement_screen.dart';
import 'screens/citizen/contact_city_admin_screen.dart';
import 'screens/citizen/poll_survey_screen.dart';
import 'screens/citizen/community_events_screen.dart';
import 'screens/citizen/news_announcement_screen.dart';
import 'screens/citizen/community_groups_screen.dart';
import 'screens/smart_healthcare_screen.dart';
import 'screens/healthcare/book_appointment_screen.dart';
import 'screens/healthcare/order_medicine_screen.dart';
import 'screens/healthcare/medical_records_screen.dart';
import 'screens/healthcare/emergency_contacts_screen.dart';
import 'screens/healthcare/nearby_hospitals_screen.dart';
import 'screens/healthcare/wellness_tips_screen.dart';
import 'screens/waste_management_screen.dart';
import 'screens/waste/collection_schedule_screen.dart';
import 'screens/waste/recycling_guidelines_screen.dart';
import 'screens/admin_login_screen.dart';
import 'screens/admin_dashboard.dart';
import 'screens/admin/add_bills_screen.dart';
import 'screens/admin/add_parking_space.dart';
import 'screens/public_transport_info.dart';
import 'screens/admin/electricity_alert.dart';
import 'screens/admin/municipal_announcement.dart';
import 'screens/admin/add_poll.dart';
import 'screens/admin/add_community_event.dart';
import 'screens/admin/add_news.dart';
import 'screens/admin/add_hosiptal.dart';
import 'screens/admin/add_doctor.dart';
import 'screens/healthcare/order_history.dart';



class Routes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';
  static const String feedback = '/feedback';
  static const String missedPickup = '/missed-pickup';
  static const String services = '/services';
  static const String bills = '/bills';
  static const String parking = '/parking';
  static const String findParking = '/findParking';
  static const String bookParking = '/bookParking';
  static const String parkingHistory = '/parkingHistory';
  static const String reportParkingIssue = '/reportParkingIssue';
  static const String citizenEngagement = '/citizenEngagement';
  static const String contactCityAdmin = '/contactCityAdmin';
  static const String pollSurvey = '/pollSurvey';
  static const String communityEvents = '/communityEvents';
  static const String newsAnnouncements = '/newsAnnouncements';
  static const String communityGroups = '/communityGroups';
  static const String smartHealthcare = '/smartHealthcare';
  static const String bookAppointment = '/bookAppointment';
  static const String orderMedicine = '/orderMedicine';
  static const String medicalRecords = '/medicalRecords';
  static const String emergencyContacts = '/emergencyContacts';
  static const String nearbyHospitals = '/nearby-hospitals';
  static const String wellnessTips = '/wellnessTips';
  static const String wasteManagement = '/wasteManagement';
  static const String collectionSchedule = '/collectionSchedule';
  static const String recyclingGuidelines = '/recyclingGuidelines';
  static const String adminlogin= '/admin_login';
  static const String admindashboard = '/admin_dashboard';
  static const String addbills ='/add_bills';
  static const String addparking ='/add_parking';
  static const String transportinfo= '/transportinfo';
  static const String electricityalert= '/electricityalert';
  static const String municipalannounce= '/announcement';
  static const String addpoll = '/addpoll';
  static const String communityevent='/events';
  static const String addnews='/addnews';
  static const String addhospital='/addhospital';
  static const String adddoctor='/adddoctor';
  static const String orderhistory='/order_history';

  static Map<String, WidgetBuilder> get allRoutes {
    return {
      login: (context) => const LoginScreen(),
      signup: (context) => const SignupScreen(),
      profile: (context) => const ProfileScreen(),
      feedback: (context) => const FeedbackGrievanceScreen(),
      missedPickup: (context) => const ReportMissedPickupScreen(),
      services: (context) => const CityServicesScreen(),
      bills: (context) => const BillsPaymentScreen(),
      parking: (context) => const ParkingDashboard(),

      bookParking: (context) => FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final email = snapshot.data?.getString('email') ?? 'guest@example.com';
            return ParkingSlotBooking(userEmail: email); // Pass dynamic email
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      parkingHistory: (context) => FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final email = snapshot.data?.getString('email') ?? 'guest@example.com';
            return ParkingHistoryScreen(userEmail: email); // Pass dynamic email
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      reportParkingIssue: (context) => const ReportParkingIssueScreen(),
      citizenEngagement: (context) => const CitizenEngagementScreen(),
      contactCityAdmin: (context) => const ContactCityAdminScreen(),
      pollSurvey: (context) => const PollSurveyScreen(),
      communityEvents: (context) => const CommunityEventsScreen(),
      newsAnnouncements: (context) => const NewsAnnouncementScreen(),
      communityGroups: (context) => const CommunityGroupsScreen(),
      smartHealthcare: (context) => const SmartHealthcareScreen(),
      bookAppointment: (context) => const BookAppointmentScreen(),
      orderMedicine: (context) => const OrderMedicineScreen(),
      medicalRecords: (context) => const MedicalRecordsScreen(),
      emergencyContacts: (context) => const EmergencyContactsScreen(),
      nearbyHospitals: (context) => const NearbyHospitalsScreen(),
      wellnessTips: (context) => const WellnessTipsScreen(),
      wasteManagement: (context) => const WasteManagementScreen(),
      collectionSchedule: (context) => const CollectionScheduleScreen(),
      recyclingGuidelines: (context) => const RecyclingGuidelinesScreen(),
      adminlogin: (context) =>  AdminLoginPage(),
      admindashboard: (context) => const AdminDashboard(),
      addbills: (context) => const AddBillScreen(),
      addparking: (context) => const AddParkingScreen(),
      transportinfo: (context) => const PublicTransportInfoPage(),
      electricityalert: (context) => const AddElectricityAlertPage(),
      municipalannounce: (context) => const AddMunicipalAnnouncementPage(),
      addpoll: (context) => const AddPollScreen(),
      communityevent: (context) => const AddCommunityEventScreen(),
      addnews: (context) => const AddNewsPage(),
      addhospital: (context) => const AddHospitalScreen(),
      adddoctor: (context) => const AddDoctorScreen(),
      orderhistory: (context) => const OrderHistoryPage(),

      dashboard: (context) => FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final email = snapshot.data?.getString('email') ?? 'guest@example.com';
            return ProfileDashboard(username: 'user', email: email);
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),

      findParking: (context) => FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final email = snapshot.data?.getString('email') ?? 'guest@example.com';
            return FindParkingScreen(userEmail: email); // Pass dynamic email
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    };
  }
}


// lib/main.dart

void main() {
  runApp(const SmartCityApp());
}

class SmartCityApp extends StatelessWidget {
  const SmartCityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart City Portal',
      theme: ThemeData(primarySwatch: Colors.teal),
      initialRoute: Routes.login, // Set initial route using the Routes class
      routes: Routes.allRoutes,  // Use all routes defined in Routes
    );
  }
}
