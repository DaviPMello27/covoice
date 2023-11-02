import 'package:covoice/controller/config_controller_inteface.dart';
import 'package:covoice/model/config_model_interface.dart';

class ConfigController implements IConfigController {
  IConfigModel configModel;

  ConfigController(this.configModel);


  @override
  Future<bool?> getBoolProperty(String property){
    return configModel.getBoolProperty(property);
  }

  @override
  Future setBoolProperty(String property, bool value){
    return configModel.setBoolProperty(property, value);
  }
}

