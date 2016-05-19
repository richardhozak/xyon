import threading
import zmq

class Remote(threading.Thread):
	def __init__(self, remote_callback):
		self.remote_callback = remote_callback
		threading.Thread.__init__(self)
		print("creating remote")

	def run(self):
		print("running remote")
		context = zmq.Context()
		socket = context.socket(zmq.SUB)
		socket.setsockopt_string(zmq.SUBSCRIBE, "")
		socket.connect("tcp://10.0.0.173:6545")
		while True:
			string = socket.recv_string()
			self.remote_callback(string)
