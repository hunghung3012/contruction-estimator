import 'package:event_bus/event_bus.dart';
import 'package:injectable/injectable.dart';

@module
abstract class EventModule {
  @singleton
  EventBus get eventBus => EventBus();
}
