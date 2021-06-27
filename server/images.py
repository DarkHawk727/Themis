# importing google_images_download module
#pip3 install git+https://github.com/con266667/google-images-download.git  
from google_images_download import google_images_download 
  
# creating object
giresponse = google_images_download.googleimagesdownload() 
  
def imageUrl(query):
    arguments = {"keywords": query,
                 "limit":1,
                 "no_download":True}
    urls = giresponse.download(arguments)
    return urls[0][query.split(',')[0]][0]
  
print(imageUrl('The smartphone also features, an in display fingerprint sensor.'))
