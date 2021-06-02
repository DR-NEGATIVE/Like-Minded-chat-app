import 'package:bloc/bloc.dart';
import '../pages/myaccountspage.dart';
import 'package:lm_login/group_stuff/search_grouporiginal.dart';
import '../pages/myorderspage.dart';
import '../pages/searchgroup.dart';
import '../pages/homepage.dart';
import '../About_us.dart';
import '../chatrooms.dart';

enum NavigationEvents {
  HomePageClickedEvent,
  MyAccountClickedEvent,
  MyOrdersClickedEvent,
  GroupSearchClickedEvent,
  AboutUs,
}

abstract class NavigationStates {}

class NavigationBloc extends Bloc<NavigationEvents, NavigationStates> {
  @override
  NavigationStates get initialState => ChatRoom();

  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event) async* {
    switch (event) {
      case NavigationEvents.HomePageClickedEvent:
        yield ChatRoom();
        break;
      case NavigationEvents.MyAccountClickedEvent:
        yield MyAccountsPage(Name: 'Dr DarkFury');
        break;
      case NavigationEvents.MyOrdersClickedEvent:
        yield MyOrdersPage();
        break;
      case NavigationEvents.GroupSearchClickedEvent:
        yield SearchPage();
        break;
      case NavigationEvents.AboutUs:
        yield About_Us();
        break;
    }
  }
}
