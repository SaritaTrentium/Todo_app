class SliderDataModel{
  final String title;
  final String subTitle;
  final String imageName;

  const SliderDataModel(this.title, this.subTitle, this.imageName);
}

List<SliderDataModel> sliderList = [
  SliderDataModel("Manage your tasks", "You can easily manage all of your daily tasks in demo for free", "assets/info/manage_todo.png"),
  SliderDataModel("Create daily routine", "Todo you can create your personalized routine to stay productive", "assets/info/daily_todo.png"),
  SliderDataModel("Organize your tasks", "You can organize your daily tasks by adding your tasks into separate categories", "assets/info/organize_todo.png"),
];
