// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:mason_logger/mason_logger.dart';
import 'package:path/path.dart' as p;
import 'package:project_cli/src/utils.dart';
import 'package:pubspec_yaml/pubspec_yaml.dart';

import 'config/cli_dir.dart';

part 'flutter_cli.dart';
part 'git_cli.dart';
part 'dart_cli.dart';
part 'intl_cli.dart';

class Cli {
  static final Logger logger = Logger();

  static Future<bool> isProjectCreating(String path) =>
      ConfigDirectory(pathProject: path).configDir.exists();

  //!T!= Створює файли послідовно, процес неможливо перервати.
  static Future<int> create(Map<FileSystemEntity, String> genFiles) async {
    for (var element in genFiles.entries) {
      try {
        if (element.key is File) {
          final file = element.key as File;
          final exist = await file.exists();
          if (!exist) await file.create(recursive: true);
          await file.writeAsString(element.value);
        } else if (element.key is Directory) {
          final dir = element.key as Directory;
          final exist = await dir.exists();
          if (!exist) await dir.create(recursive: true);
        }
      } catch (e) {
        logger.err("Error create ${element.key.path}");
        rethrow;
      }
    }
    return ExitCode.success.code;
  }

  /// starts the command with the given [cmd] and [args].
  static Future<int> start(
    String cmd,
    List<String> args, {
    bool throwOnError = true,
    String? workingDirectory,
  }) async {
    final result = await Process.start(cmd, args,
        workingDirectory: workingDirectory, runInShell: true);
    await result.stdout
        .transform(utf8.decoder)
        .map((event) => event.replaceAll('\n\n\n', '\n'))
        .forEach(
          (element) => logger.info(element.toString()),
        );
    if (throwOnError) {
      _throwIfProcessFailed(
          ProcessResult(
              result.pid, await result.exitCode, result.stdout, result.stderr),
          cmd,
          args);
    }
    return await result.exitCode;
  }

  /// Runs the specified [cmd] with the provided [args].
  static Future<ProcessResult> run(
    String cmd,
    List<String> args, {
    bool throwOnError = true,
    String? workingDirectory,
  }) async {
    logger.detail('Running $cmd with $args');
    final result = await Process.run(
      cmd,
      args,
      workingDirectory: workingDirectory,
      runInShell: true,
    );

    logger.detail('Output:\n${result.stdout}');

    if (throwOnError) {
      _throwIfProcessFailed(result, cmd, args);
    }
    return result;
  }

  /// Runs the specified [cmd] with the provided [args] and returns the stdout in specified condition.
  static Iterable<Future<T>> runWhere<T>({
    required Future<T> Function(FileSystemEntity) run,
    required bool Function(FileSystemEntity) where,
    String cwd = '.',
  }) {
    return Directory(cwd).listSync(recursive: true).where(where).map(run);
  }

  /// Throws an error if the [pr] indicates a failure.
  static void _throwIfProcessFailed(
    ProcessResult pr,
    String process,
    List<String> args,
  ) {
    if (pr.exitCode != 0) {
      final values = {
        'Standard out': pr.stdout.toString().trim(),
        'Standard error': pr.stderr.toString().trim()
      }..removeWhere((k, v) => v.isEmpty);

      var message = 'Unknown error';
      if (values.isNotEmpty) {
        message = values.entries.map((e) => '${e.key}\n${e.value}').join('\n');
      }

      throw ProcessException(process, args, message, pr.exitCode);
    }
  }
}

const _ignoredDirectories = {
  'ios',
  'android',
  'windows',
  'linux',
  'macos',
  '.symlinks',
  '.plugin_symlinks',
  '.dart_tool',
  'build',
  '.fvm',
};

/// Checks is directory contains pubspec.yaml file.
bool _isPubspec(FileSystemEntity entity) {
  final segments = p.split(entity.path).toSet();
  if (segments.intersection(_ignoredDirectories).isNotEmpty) return false;
  if (entity is! File) return false;
  return p.basename(entity.path) == 'pubspec.yaml';
}
