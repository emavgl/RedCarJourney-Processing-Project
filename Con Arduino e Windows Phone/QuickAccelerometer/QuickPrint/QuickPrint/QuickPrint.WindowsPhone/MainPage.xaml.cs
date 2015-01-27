using QuickPrint.Common;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices.WindowsRuntime;
using Windows.Devices.Sensors;
using Windows.Foundation;
using Windows.Foundation.Collections;
using Windows.Graphics.Display;
using Windows.UI.Core;
using Windows.UI.Popups;
using Windows.UI.ViewManagement;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Controls.Primitives;
using Windows.UI.Xaml.Data;
using Windows.UI.Xaml.Input;
using Windows.UI.Xaml.Media;
using Windows.UI.Xaml.Navigation;
// The Basic Page item template is documented at http://go.microsoft.com/fwlink/?LinkID=390556

using WindowsBluetooth;

namespace QuickPrint
{
    /// <summary>
    /// An empty page that can be used on its own or navigated to within a Frame.
    /// </summary>
    public sealed partial class MainPage : Page
    {
        private NavigationHelper navigationHelper;
        private ObservableDictionary defaultViewModel = new ObservableDictionary();

        BluetoothManager myBluetooth;

        string bluetoothDevice = "HC-06";

        public Accelerometer accelerometer { get; set; }
        private uint desiredReportInterval { get; set; }

        public MainPage()
        {
            this.InitializeComponent();

            myBluetooth = new BluetoothManager();
            myBluetooth.DiagnosticsChangedNotification += new BluetoothManager.DiagnosticsMessageDelegate(diagnosticsStringReceived);
            myBluetooth.StatusChangedNotification += new BluetoothManager.StatusChangedDelegate(bluetoothStatusChanged);
            getAccelerometerData();

            this.navigationHelper = new NavigationHelper(this);
            this.navigationHelper.LoadState += this.NavigationHelper_LoadState;
            this.navigationHelper.SaveState += this.NavigationHelper_SaveState;
        }

        private void getAccelerometerData()
        {
            accelerometer = Accelerometer.GetDefault();
            if (accelerometer != null)
            {
                // Select a report interval that is both suitable for the purposes of the app and supported by the sensor.
                // This value will be used later to activate the sensor.
                uint minReportInterval = accelerometer.MinimumReportInterval;
                desiredReportInterval = minReportInterval > 16 ? minReportInterval : 16;


                accelerometer.ReportInterval = desiredReportInterval;

                //add event for accelerometer readings
                accelerometer.ReadingChanged += new TypedEventHandler<Accelerometer, AccelerometerReadingChangedEventArgs>(ReadingChanged);

            }
            else
            {
                MessageDialog ms = new MessageDialog("No accelerometer Found");
                ms.ShowAsync();
            }
        }

        private async void ReadingChanged(Accelerometer sender, AccelerometerReadingChangedEventArgs args)
        {
            await Dispatcher.RunAsync(CoreDispatcherPriority.Normal, () =>
            {
                AccelerometerReading reading = args.Reading;
                int a = (int)((reading.AccelerationY*100)+117);
                string accY = String.Format("{0,5:0.00}", a);
                Debug.WriteLine(accY);
                //System.Diagnostics.Debug.WriteLine("{0} {1} {2}", reading.AccelerationX, reading.AccelerationY, reading.AccelerationZ);
                sendAsByte(a);
            });
        }

        #region Bluetooth Dialogue
        void setControlEnabled(bool state)
        {
            SendButton.IsEnabled = state;
            ConnectButton.IsEnabled = !state;
        }

        async void displayMessage(string message)
        {
            MessageDialog mess = new MessageDialog(message);
            await mess.ShowAsync();
        }

        void bluetoothStatusChanged(BluetoothManager.ManagerStatus status)
        {
            Dispatcher.RunAsync(Windows.UI.Core.CoreDispatcherPriority.Normal, () =>
            {
                switch (status)
                {
                    case BluetoothManager.ManagerStatus.Idle:
                        setControlEnabled(false);
                        break;
                    case BluetoothManager.ManagerStatus.GettingConnection:
                        ConnectProgressRing.IsActive = true;
                        break;
                    case BluetoothManager.ManagerStatus.FailedToGetConnection:
                        displayMessage("Failed to get connection. Press Connect to retry.");
                        ConnectProgressRing.IsActive = false;
                        setControlEnabled(false);
                        break;
                    case BluetoothManager.ManagerStatus.GotConnection:
                        ConnectProgressRing.IsActive = false;
                        setControlEnabled(true);
                        break;
                    case BluetoothManager.ManagerStatus.LostConnection:
                        displayMessage("Lost connection. Press Connect to reconnect.");
                        setControlEnabled(false);
                        break;
                }
            });
        }

        async void diagnosticsStringReceived(string message)
        {
            await Dispatcher.RunAsync(Windows.UI.Core.CoreDispatcherPriority.Normal, () =>
            {
                ConnectStatus.Text = message;
            });
        }

        private void ConnectButton_Click(object sender, RoutedEventArgs e)
        {
            myBluetooth.ResetToIdle();
            startBluetooth();
        }

        private void startBluetooth()
        {
            if (myBluetooth.Status == BluetoothManager.ManagerStatus.Idle)
            {
                myBluetooth.Initialise(bluetoothDevice);
            }
        }

        /// <summary>
        /// Gets the <see cref="NavigationHelper"/> associated with this <see cref="Page"/>.
        /// </summary>
        public NavigationHelper NavigationHelper
        {
            get { return this.navigationHelper; }
        }

        /// <summary>
        /// Gets the view model for this <see cref="Page"/>.
        /// This can be changed to a strongly typed view model.
        /// </summary>
        public ObservableDictionary DefaultViewModel
        {
            get { return this.defaultViewModel; }
        }

        /// <summary>
        /// Populates the page with content passed during navigation.  Any saved state is also
        /// provided when recreating a page from a prior session.
        /// </summary>
        /// <param name="sender">
        /// The source of the event; typically <see cref="NavigationHelper"/>
        /// </param>
        /// <param name="e">Event data that provides both the navigation parameter passed to
        /// <see cref="Frame.Navigate(Type, Object)"/> when this page was initially requested and
        /// a dictionary of state preserved by this page during an earlier
        /// session.  The state will be null the first time a page is visited.</param>
        private void NavigationHelper_LoadState(object sender, LoadStateEventArgs e)
        {
            startBluetooth();
        }

        /// <summary>
        /// Preserves state associated with this page in case the application is suspended or the
        /// page is discarded from the navigation cache.  Values must conform to the serialization
        /// requirements of <see cref="SuspensionManager.SessionState"/>.
        /// </summary>
        /// <param name="sender">The source of the event; typically <see cref="NavigationHelper"/></param>
        /// <param name="e">Event data that provides an empty dictionary to be populated with
        /// serializable state.</param>
        private void NavigationHelper_SaveState(object sender, SaveStateEventArgs e)
        {
        }

        #region NavigationHelper registration

        /// <summary>
        /// The methods provided in this section are simply used to allow
        /// NavigationHelper to respond to the page's navigation methods.
        /// <para>
        /// Page specific logic should be placed in event handlers for the  
        /// <see cref="NavigationHelper.LoadState"/>
        /// and <see cref="NavigationHelper.SaveState"/>.
        /// The navigation parameter is available in the LoadState method 
        /// in addition to page state preserved during an earlier session.
        /// </para>
        /// </summary>
        /// <param name="e">Provides data for navigation methods and event
        /// handlers that cannot cancel the navigation request.</param>
        protected override void OnNavigatedTo(NavigationEventArgs e)
        {
            this.navigationHelper.OnNavigatedTo(e);
        }

        protected override void OnNavigatedFrom(NavigationEventArgs e)
        {
            this.navigationHelper.OnNavigatedFrom(e);
        }

        #endregion

        private void SendButtonClick(object sender, RoutedEventArgs e)
        {
            if(myBluetooth.Status == BluetoothManager.ManagerStatus.GotConnection)
            {
                byte[] buffer = new byte[messageTextBlock.Text.Length];
                for (int i = 0; i < buffer.Length;i++ )
                {
                    buffer[i] = (byte)messageTextBlock.Text[i];
                }
                myBluetooth.SendBytes(buffer);
            }
        }

        private void sendAsByte(int a) {
            byte[] buffer = { (byte)a };
            if (myBluetooth.Status == BluetoothManager.ManagerStatus.GotConnection)
            {
                myBluetooth.SendBytes(buffer);

            }
        }

        private void sendFunction(string a)
        {
            //a += "a";
            if (myBluetooth.Status == BluetoothManager.ManagerStatus.GotConnection)
            {
                byte[] buffer = new byte[a.Length];
                for (int i = 0; i < buffer.Length; i++)
                {
                    buffer[i] = (byte)a[i];
                }
                myBluetooth.SendBytes(buffer);

            }
        }
        #endregion 



    }
}
