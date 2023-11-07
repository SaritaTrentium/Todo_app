import 'package:todo_app/common/resources/string_resources.dart';

class SliderDataModel{
  final String title;
  final String subTitle;
  final String imageName;

  const SliderDataModel(this.title, this.subTitle, this.imageName);
}

List<SliderDataModel> sliderList = [
  SliderDataModel(StringResources.getManageTitle,StringResources.getManageSubtitle, StringResources.getManageImage ),
  SliderDataModel(StringResources.getCreateTitle,StringResources.getCreateSubTitle , StringResources.getCreateImage),
  SliderDataModel(StringResources.getOrganizeTitle,StringResources.getOrganizeSubTitle , StringResources.getOrganizeImage),
];
