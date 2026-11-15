face_cap = cv2.CascadeClassifier("C:\Users\vikash raj\AppData\Local\Programs\Python\Python314\Lib\site-packages")
# video_cap =

import cv2
video_cap = cv2.VideoCapture(0)
while True:
    ret,video_data = video_cap.read()
    color = cv2.cvtColor(video_cap,cv2.COLOR_BGR2GRAY)
    faces = face_cap.detectMultiScale(
        col,
        scaleFcator = 1.1,
        MinNeighbour=5,
        MinSize=(30,30),
        flags=cv2.CASCADE_SCALE_IMAGE
    )
    for(x,y,w,h) in faces:
        cv2.rectangle(video_data,(x,y),(x+y,x+h),(0,225,0),2)
    #make a frame to detect the picture
    cv2.imshow("live_video",video_data)
    if cv2.waitKey(10) == ord("a"):     #we can stop the video at a particular duration
        break
video_cap.release()
