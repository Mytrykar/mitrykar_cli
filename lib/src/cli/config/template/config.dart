import 'package:project_cli/src/cli/config/cli_dir.dart';
import 'package:project_cli/src/cli/config/cli_yaml.dart';
import 'package:project_cli/src/utils.dart';
import 'package:project_cli/src/version.dart';

extension ConfigYamlTemplate on ConfigDirectory {
  String templateConfig(ProjectType projectType) {
    String routes =
        """# Додані через project_cli маршрути, key: Screen Value: /path
${ConfigYamlTokens.pathRoute}: ${tree[ConfigYamlTokens.pathRoute]}""";

    return """
# Тут зберігається конфігурація Cli_project генератора.
# ! Прохання не змінювати структуру проекта, та якщо ви все ж
# таки змінили, то повідомте цю конфігурацію.
${ConfigYamlTokens.projectType}: ${projectType.name}

${ConfigYamlTokens.version}: $packageVersion

${projectType == ProjectType.app ? routes : ""}

""";
  }
}
