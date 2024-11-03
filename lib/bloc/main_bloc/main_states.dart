abstract class MainStates {}

class MainInitial extends MainStates {}

class MainSuccess extends MainStates {
  String msg;
  MainSuccess(this.msg);
}

class MainFailure extends MainStates {
  String msg;
  MainFailure(this.msg);
}
