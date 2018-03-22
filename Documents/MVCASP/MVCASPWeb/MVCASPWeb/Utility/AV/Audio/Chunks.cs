using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MVCASPWeb.AV.Audio
{
    
        public class WaveHeader
        {
            public string sGroupID; // RIFF
            public uint dwFileLength; // total file length minus 8, which is taken up by RIFF
            public string sRiffType; // always WAVE

            /// <summary>
            /// Initializes a WaveHeader object with the default values.
            /// </summary>
            public WaveHeader()
            {
                dwFileLength = 0;
                sGroupID = "RIFF";
                sRiffType = "WAVE";
            }
        }


        public class WaveFormatChunk
        {
            public string sChunkID;         // Four bytes: "fmt "
            public uint dwChunkSize;        // Length of header in bytes
            public ushort wFormatTag;       // 1 (MS PCM)
            public ushort wChannels;        // Number of channels
            public uint dwSamplesPerSec;    // Frequency of the audio in Hz... 44100
            public uint dwAvgBytesPerSec;   // for estimating RAM allocation
            public ushort wBlockAlign;      // sample frame size, in bytes
            public ushort wBitsPerSample;    // bits per sample

            /// <summary>
            /// Initializes a format chunk with the following properties:
            /// Sample rate: 44100 Hz
            /// Channels: Stereo
            /// Bit depth: 16-bit
            /// </summary>
            public WaveFormatChunk()
            {
                sChunkID = "fmt ";
                dwChunkSize = 16;
                wFormatTag = 1;
                wChannels = 2;
                dwSamplesPerSec = 44100;
                wBitsPerSample = 16;
                wBlockAlign = (ushort)(wChannels * (wBitsPerSample / 8));
                dwAvgBytesPerSec = dwSamplesPerSec * wBlockAlign;
            }
        }


        public class WaveDataChunk
        {
            public string sChunkID;     // "data"
            public uint dwChunkSize;    // Length of header in bytes
            public short[] shortArray;  // 8-bit audio

            /// <summary>
            /// Initializes a new data chunk with default values.
            /// </summary>
            public WaveDataChunk()
            {
                shortArray = new short[0];
                dwChunkSize = 0;
                sChunkID = "data";
            }
        }
}
