using Android.App;
using Android.Widget;
using Android.OS;
using Android.Content;
using Android.Views;
using Android.Runtime;
using System;
using Java.Interop;

using Shared;

namespace Droid
{
    [Activity(Label = "Droid", MainLauncher = true, Icon = "@drawable/icon")]
    public class MainActivity : Activity
    {
        protected override void OnCreate(Bundle bundle)
        {
            base.OnCreate(bundle);
			MyClass fromShared = new MyClass();
			fromShared.name = "abc";

			// Set our view from the "main" layout resource
            SetContentView(Resource.Layout.Main);

			var editText = FindViewById<EditText>(Resource.Id.edittext);
			editText.Text = fromShared.name;

            var butt = FindViewById<Button>(Resource.Id.SendButton);

            //butt.SetOnClickListener(this);
            butt.Click += delegate{
                 var geoUri = Android.Net.Uri.Parse("geo:42.374260,-71.120824");
                 var mapIntent = new Intent(Intent.ActionView, geoUri);
                 StartActivity(mapIntent);
             };

          

     
        }

        //[Java.Interop.Export("btnOneClick")]
        //public void btnOneClick(View V)
        //{
        //    var geoUri = Android.Net.Uri.Parse("geo:42.374260,-71.120824");
        //    var mapIntent = new Intent(Intent.ActionView, geoUri);
        //    StartActivity(mapIntent);
        //}
    }
}





