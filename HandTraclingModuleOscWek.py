"""
Hand Tracing Module
By: Murtaza Hassan
Youtube: http://www.youtube.com/c/MurtazasWorkshopRoboticsandAI
Website: https://www.computervision.zone
"""
import cv2
import mediapipe as mp
import time

import argparse
from pythonosc import udp_client

class handDetector():
    def __init__(self, mode=False, maxHands=2, modelC=1, detectionCon=0.5, trackCon=0.5):
        self.mode = mode
        self.maxHands = maxHands
        self.detectionCon = detectionCon
        self.trackCon = trackCon
        self.modelC = modelC
        self.mpHands = mp.solutions.hands
        self.hands = self.mpHands.Hands(self.mode, self.maxHands, self.modelC,
                                        self.detectionCon, self.trackCon)
        self.mpDraw = mp.solutions.drawing_utils
    def findHands(self, img, draw=True):
        imgRGB = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
        self.results = self.hands.process(imgRGB)
        # print(results.multi_hand_landmarks)
        if self.results.multi_hand_landmarks:
            for handLms in self.results.multi_hand_landmarks:
                if draw:
                    self.mpDraw.draw_landmarks(img, handLms,
                                               self.mpHands.HAND_CONNECTIONS)
        return img
    def findPosition(self, img, handNo=0, draw=True):
        lmList = []
        lmListF = []
        if self.results.multi_hand_landmarks:
            myHand = self.results.multi_hand_landmarks[handNo]
            for id, lm in enumerate(myHand.landmark):
                # print(id, lm)
                h, w, c = img.shape
                cx, cy = int(lm.x * w), int(lm.y * h)
                cxF, cyF = lm.x * w, lm.y * h
                # print(id, cx, cy)
                idF = float(id)
                lmListF.append(cxF)
                lmListF.append(cyF)
                lmList.append([id, cx, cy])
                if draw:
                    cv2.circle(img, (cx, cy), 15, (255, 0, 255), cv2.FILLED)
        return lmList,lmListF
def main():
    pTime = 0
    cTime = 0
    cap = cv2.VideoCapture(0)
    detector = handDetector()

    parser = argparse.ArgumentParser()
    parser.add_argument("--ip", default="127.0.0.1",
    help="ip OSC serve")
    parser.add_argument("--port", type=int, default=6448,
    help="port OSC server")
    args = parser.parse_args()

    client = udp_client.SimpleUDPClient(args.ip, args.port)

    fingerId=8
    xFinger=0
    yFinger=0

    while True:
        success, img = cap.read()
        img = detector.findHands(img)
        # formas de números con las manos
        landmarks_list = detector.findPosition(img)
  
        if len(landmarks_list[0]) != 0:
            
            print(landmarks_list[0])
            
            #dedo, coordendas
            if len(landmarks_list[0][fingerId])!=0:
                print("x:",landmarks_list[0][fingerId][1])
                print("y:",landmarks_list[0][fingerId][2])
                xFinger=landmarks_list[0][fingerId][1]
                yFinger=landmarks_list[0][fingerId][2]
            else:
                xFinger=0
                yFinger=0


        cTime = time.time()
        fps = 1 / (cTime - pTime)
        pTime = cTime
        cv2.putText(img, str(int(fps)), (10, 70), cv2.FONT_HERSHEY_PLAIN, 3,
                    (255, 0, 255), 3)
        cv2.imshow("Image", img)
        cv2.waitKey(1)
        client.send_message("/utn/mfp/", [float(xFinger),float(yFinger)])


if __name__ == "__main__":
    main()