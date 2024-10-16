import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../services/api.dart';
import '../viewmodels/dashboard_viewmodel.dart';

List<SingleChildWidget> providers = [
  ...independentService,
  ...universalService,
];

List<SingleChildWidget> independentService = [
  Provider.value(value: api),
];

List<SingleChildWidget> universalService = [
  ChangeNotifierProvider<DashboardViewModel>(
      create: (context) => DashboardViewModel(context)),
];
