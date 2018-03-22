
//******************************************************************************
// Module           :   YouTubeScript.cs
// Author           :   Alexander Bell
// Copyright        :   2009 Infosoft International Inc
// Date Created     :   06/29/2009
// Last Modified    :   07/18/2009
// Version          :   1.0.0.1
// Description      :   YouTube Player Javascript generator

//******************************************************************************
// DISCLAIMER: This Application is provide on AS IS basis without any warranty
//******************************************************************************

//******************************************************************************
// TERMS OF USE     :   This module is copyrighted.
//                  :   You can use it at your sole risk provided that you keep
//                  :   the original copyright note.
//******************************************************************************

using System;
using System.Text;

///*****************************************************************************
/// <summary>
/// Generate Javascript to embed YouTube Video Player in ASP.NET web page
/// </summary> 
public static class YouTubeScript
{
    #region YouTube Player default script: no autoplay, 320x240
    /// <summary>
    /// YouTube Player default script: no autoplay, 320x240
    /// </summary>
    /// <param name="id">id</param>
    /// <param name="auto">int</param>
    /// <returns>string</returns>
    public static string Get(string id)
    { return Get(id, false, 320, 240); }
    #endregion

    #region YouTube Player script w/autoplay option (320x240)
    /// <summary>
    /// YouTube Player script w/autoplay option (320x240)
    /// </summary>
    /// <param name="id">id</param>
    /// <param name="auto">bool</param>
    /// <returns>string</returns>
    public static string Get(string id, bool auto)
    { return Get(id, auto, 320, 240); }
    #endregion

    #region YouTube Player script w/autoplay option (320x240)
    /// <summary>
    /// YouTube Player script w/autoplay option (320x240)
    /// </summary>
    /// <param name="id">id</param>
    /// <param name="auto">int</param>
    /// <returns>string</returns>
    public static string Get(string id, int auto)
    { return Get(id, ((auto == 1) ? true : false), 320, 240); }
    #endregion

    #region YouTube Player script w/selectable: autoplay and W/H
    /// <summary>
    /// YouTube Player script w/selectable: autoplay and W/H options
    /// </summary>
    /// <param name="id">id</param>
    /// <param name="auto">bool</param>
    /// <param name="W">int</param>
    /// <param name="H">int</param>
    /// <returns>string</returns>
    public static string Get(string id, bool auto, int W, int H)
    { return Get(id, auto, W, H, true); }
    #endregion

    #region YouTube Player script w/selectable: autoplay, W/H and default border
    /// <summary>
    /// YouTube Player script w/selectable: autoplay, W/H, default border color 
    /// </summary>
    /// <param name="id">id</param>
    /// <param name="auto">bool</param>
    /// <param name="W">int</param>
    /// <param name="H">int</param>
    /// <param name="Border">bool</param>
    /// <returns>string</returns>
    public static string Get(string id, bool auto, int W, int H, bool Border)
    { return Get(id, auto, W, H, Border, "0x2b405b", "0x6b8ab6",0 ); }
    #endregion

    #region YouTube Player script w/selectable: autoplay, W/H and border color
    /// <summary>
    /// YouTube Player script w/selectable: autoplay, W/H and border color
    /// </summary>
    /// <param name="id">id</param>
    /// <param name="auto">bool</param>
    /// <param name="W">int</param>
    /// <param name="H">int</param>
    /// <param name="Border">bool</param>
    /// <param name="C1">string</param>
    /// <param name="C2">string</param>
    /// <returns>string</returns>
    public static string Get
            (string id,
            bool auto, 
            int W, 
            int H, 
            string C1, 
            string C2)
   { return Get(id, auto, W, H, true, C1,C2, 0); }
    #endregion

    #region YouTube Player script w/selectable: autoplay, W/H and border color
    /// <summary>
    /// YouTube Player script w/selectable: autoplay, W/H and border color
    /// </summary>
    /// <param name="id">id</param>
    /// <param name="auto">bool</param>
    /// <param name="W">int</param>
    /// <param name="H">int</param>
    /// <param name="Border">bool</param>
    /// <param name="C1">string</param>
    /// <param name="C2">string</param>
    /// <returns>string</returns>
    public static string Get
            (string id,
            bool auto,
            int W,
            int H,
            bool Border,
            string C1,
            string C2, 
            int Start)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(@"<embed src='http://www.youtube.com/v/");

        // select the youTube item to play
        sb.Append(id);

        // set autoplay options (indicates number of plays)
        if (auto) sb.Append("&autoplay=1");

        // no related items to display
        sb.Append("&rel=0");

        // set border color 1 and 2
        if (Border)
        {
            sb.Append("&border=1");
            sb.Append("&color1=" + @C1);
            sb.Append("&color2=" + @C2);
        }

        // start position
        if (Start>0) sb.Append("&start=" + Start.ToString());
        
        // allow full screen
        sb.Append("&fs=1");

        // closing single quote after parameter list
        sb.Append("' ");

        
        sb.Append("type='application/x-shockwave-flash' ");

        // add id
        sb.Append("id='youTubePlayer" + DateTime.Now.Millisecond.ToString() + "' ");
        sb.Append("allowscriptaccess='never' enableJavascript ='false' ");

        // set parameters: allowfullscreen
        sb.Append("allowfullscreen='true' ");

        // set width
        sb.Append("width='" + W.ToString() + "' ");

        // set height
        sb.Append("height='" + H.ToString() + "' ");

        sb.Append(@"></embed>");

        // get final script
        string scr = sb.ToString();

        sb = null;
        return scr;
    }
    #endregion
}
///*****************************************************************************************