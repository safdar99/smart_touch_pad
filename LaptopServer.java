import java.net.InetAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Arrays;
import java.io.*;
import java.awt.*;

class LaptopServer {

    static void po(Object... o) {
        System.out.println(Arrays.deepToString(o));
    }
    //Unicast ip
    // Socket s = new Socket("224.0.0.251", 5353);
    public static void main(String args[]) throws Exception {
        InetAddress inetAddress = InetAddress.getLocalHost();
        System.out.println("IP Address:- " + inetAddress.getHostAddress());
        System.out.println("Host Name:- " + inetAddress.getHostName());
        Robot robot = new Robot();
        ServerSocket server;
        Socket socket;
        int port = 3000;
        try {
            server = new ServerSocket(port);
            System.out.println("Server started at " + server.getLocalPort());

            while (true) {
                po("while1");
                System.out.println("Waiting for a client ...");
                socket = server.accept();
                System.out.println("Client accepted");

                DataInputStream in = new DataInputStream(new BufferedInputStream(socket.getInputStream()));

                // reads message from client until "Over" is sent
                int msg = in.read();
                while (msg != 4) {
                    StringBuilder line = new StringBuilder();
                    while (msg != 3 && msg != -1) {
                        line.append((char) msg);
                        msg = in.read();
                    }
                    if (msg == -1) break; //client died
                    String[] coords = line.substring(2).split(" ");
                    Integer dx = Integer.parseInt(coords[0]);
                    Integer dy = Integer.parseInt(coords[1]);
                    Point mouse = MouseInfo.getPointerInfo().getLocation();
                    int mouseX = (int) (mouse.getX() + 1.5 * dx);
                    int mouseY = (int) (mouse.getY() + 1.5 * dy);
                    robot.mouseMove(mouseX, mouseY);
                    msg = in.read();
                }
                System.out.println("Closing connection");
            }
        } catch (Exception e) {

            System.out.println("Client not accepted " + e);
        }
    }
}