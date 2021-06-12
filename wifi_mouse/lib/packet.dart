class Packet {
  final String type;
  final String message;

  const Packet(this.type, {this.message = ""});
  final String etx = '\u0003';

  String getString() {
    if (type == '02') {
      return "\u0004";
    }
    return "$type$message$etx";
  }
}
