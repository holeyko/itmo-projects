#include <iostream>
#include <omp.h>
#include <cassert>
#include <vector>

#include "ImageSource.h"

using namespace std;

int main(int argc, char *argv[]) {
    assert(argc == 5);
    unsigned int threadsCount = stoi(argv[1]);
    std::string inputFileName = argv[2];
    std::string outputFileName = argv[3];
    float rationIgnoredData = stof(argv[4]);

    omp_set_num_threads(threadsCount);
    omp_set_schedule(omp_sched_dynamic, 100000);

    ImageSource source(inputFileName);
    stringstream imageParams;
    bool isRGB = false;

    //Read file format
    string fileFormat = source.readLine();
    if (fileFormat.compare("P5") != 0 && fileFormat.compare("P6") != 0) {
        throw invalid_argument("Unecpected file format ");               //TODO: make normat exception handling
    }
    if (fileFormat.compare("P6") == 0) {
        isRGB = true;
    }

    //Create space for pixels data
    vector<vector<unsigned char>> imageData;
    imageData.emplace_back();
    if (isRGB) {
        imageData.emplace_back();
        imageData.emplace_back();
    }

    //Read width and height image
    string widthAndHeight = source.readLine();
    imageParams << widthAndHeight;
    unsigned int width, height;
    imageParams >> width >> height;

    //Read max value pixel
    string maxValueOfPixel = source.readLine();

    //Read pixels of image
    unsigned char pixelData;
    unsigned int countPixels = width * height;
    unsigned int countChannels = 1;
    if (isRGB) {
        countChannels = 3;
    }
    while (!source.isEnd()) {
        for (int i = 0; i < countChannels; i++) {
            pixelData = source.read();
            imageData[i].push_back(pixelData);
        }
    }

    source.close();

    double start = omp_get_wtime();

    //Tagging ignored data
    vector<vector<bool>> ignoredData;
    for (int numChannal = 0; numChannal < countChannels; numChannal++) {
        vector<bool> tmp;
        ignoredData.push_back(tmp);
    }
#pragma omp parallel for
    for (int numChannal = 0; numChannal < countChannels; numChannal++) {
        vector<bool> ignoredInChannels;
        unsigned int countValues[256] = {0};
        for (int numPixel = 0; numPixel < countPixels; numPixel++) {
            countValues[imageData[numChannal][numPixel]]++;
            ignoredInChannels.push_back(false);
        }
        for (int i = 0; i < 2; i++) {
            unsigned int countIgnoredData = countPixels * rationIgnoredData;
            unsigned int curCountIgnoredData = 0;
            unsigned int curValue = i*255;
            unsigned int controlValue = 0;
            while (curCountIgnoredData != countIgnoredData) {
                if (countValues[curValue] == 0) {
                    curValue += 1 + i * (-2);
                    continue;
                }
                if (countIgnoredData >= curCountIgnoredData + countValues[curValue]) {
                    curCountIgnoredData += countValues[curValue];
                    curValue += 1 + i * (-2);
                } else {
                    controlValue = countIgnoredData - curCountIgnoredData;
                    break;
                }
            }
            for (int numPixel = 0; numPixel < countPixels; numPixel++) {
                if (i == 0 && 0 <= imageData[numChannal][numPixel] && imageData[numChannal][numPixel] < curValue) {
                    ignoredInChannels[numPixel] = true;
                } else if (i == 1 && curValue < imageData[numChannal][numPixel] && imageData[numChannal][numPixel] <= 255){
                    ignoredInChannels[numPixel] = true;
                } else if (controlValue != 0 && imageData[numChannal][numPixel] == curValue) {
                    ignoredInChannels[numPixel] = true;
                    controlValue--;
                }
            }
        }
        ignoredData[numChannal] = ignoredInChannels;
    }

    //
    unsigned char minValue = 255;
    unsigned char maxValue = 0;
#pragma omp parallel for
    for (int numChannel = 0; numChannel < countChannels; numChannel++) {
        for (int numPixel = 0; numPixel < countPixels; numPixel++) {
            if (!ignoredData[numChannel][numPixel]) {
                minValue = min(minValue, imageData[numChannel][numPixel]);
                maxValue = max(maxValue, imageData[numChannel][numPixel]);
            }
        }
    }

    if (minValue != maxValue) {
#pragma omp parallel for
        for (int numChannel = 0; numChannel < countChannels; numChannel++) {
            for (int numPixel = 0; numPixel < countPixels; numPixel++) {
                if (imageData[numChannel][numPixel] - minValue < 0) {
                    imageData[numChannel][numPixel] = 0;
                } else if ((imageData[numChannel][numPixel] - minValue) * 255 / (maxValue - minValue) > 255) {
                    imageData[numChannel][numPixel] = 255;
                } else {
                    imageData[numChannel][numPixel] = (imageData[numChannel][numPixel] - minValue) * 255 / (maxValue - minValue);
                }
            }
        }
    }

    double end = omp_get_wtime();
    printf("Time (%d thread(s)): %lf ms\\n", threadsCount, (end - start) * 1000);

    fstream outputFile (outputFileName, ios::app | ios::binary);
    outputFile << fileFormat << endl;
    outputFile << width << " " << height << endl;
    outputFile << maxValueOfPixel << endl;
    for (int numPixel = 0; numPixel < countPixels; numPixel++) {
        for (int numChannel = 0; numChannel < countChannels; numChannel++) {
            outputFile << imageData[numChannel][numPixel];
        }
    }
    outputFile.close();

    return 0;
}