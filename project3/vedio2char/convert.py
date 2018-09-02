import numpy as np
import os
import sys
import cv2
from PIL import Image

frames = []
def get_frame_count(videofile):
    frame_count = 0
    video_cap = cv2.VideoCapture(videofile)
    while (video_cap.isOpened()):
        ret, frame = video_cap.read()
        if ret is False:
            break
        frame_count += 1
        frames.append(frame)
    return frame_count

def video_to_frame(jiange):
    text = open("text.txt", "w")
    i = 0
    for frame in frames:
        if i % jiange == 0:
            gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY) 
            cv2.imwrite("frame.png", frame)
            frame_to_char(text)
        i += 1
    text.close()
    os.system("del frame.png")

def resize_frame(img):
    return Image.open(img, 'r').convert("L").resize(size)

def frame_to_char(text):
    gray_char=['@','#','$','&','*','o','/','{','[','(',
               '|','!','^','~','-','_',':',';',',','.','`',' ']
    
    frame = resize_frame('frame.png')
    text.write('\"')
    for y in range(size[1]):
        for x in range(size[0]):
            gray = frame.getpixel((x,y))
            char = gray_char[int(gray/(255/(len(gray_char)-1)))]
            text.write(char)
        text.write("\\\n")
    text.write('",\n')

if __name__ == '__main__':
    size = (80, 25) #size of output frame (x,y)
    frame_count = get_frame_count(sys.argv[1])
    print(frame_count)
    need = 10      #how much frames need
    video_to_frame(frame_count // need) 

