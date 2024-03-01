abstract class LiveStreamBaseEvent {
  const LiveStreamBaseEvent();
}

class LiveStreamInitEvent extends LiveStreamBaseEvent {
  const LiveStreamInitEvent();
}

class LiveStreamSocketConnectEvent extends LiveStreamBaseEvent {
  const LiveStreamSocketConnectEvent();
}
