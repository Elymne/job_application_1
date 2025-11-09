class MyFormState {
  final MyFormStatus status;
  final int? step;
  final String? errorMessage;

  MyFormState({this.status = MyFormStatus.waiting, this.step, this.errorMessage});
}

enum MyFormStatus { waiting, success, failure }
