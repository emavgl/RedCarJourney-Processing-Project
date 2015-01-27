using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices.WindowsRuntime;
using Windows.Foundation;
using Windows.Foundation.Collections;
using Windows.UI.Popups;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Controls.Primitives;
using Windows.UI.Xaml.Data;
using Windows.UI.Xaml.Input;
using Windows.UI.Xaml.Media;
using Windows.UI.Xaml.Navigation;
using WindowsBluetooth;

// The Blank Page item template is documented at http://go.microsoft.com/fwlink/?LinkId=234238

namespace QuickPrint
{
    /// <summary>
    /// An empty page that can be used on its own or navigated to within a Frame.
    /// </summary>
    public sealed partial class MainPage : Page
    {
        BluetoothManager myBluetooth;

        string bluetoothDevice = "PRINTER";

        public MainPage()
        {
            this.InitializeComponent();

            myBluetooth = new BluetoothManager();
            myBluetooth.DiagnosticsChangedNotification += new BluetoothManager.DiagnosticsMessageDelegate(diagnosticsStringReceived);
            myBluetooth.StatusChangedNotification += new BluetoothManager.StatusChangedDelegate(bluetoothStatusChanged);
        }

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

        private void SendButtonClick(object sender, RoutedEventArgs e)
        {
            if (myBluetooth.Status == BluetoothManager.ManagerStatus.GotConnection)
            {
                byte[] buffer = new byte[messageTextBlock.Text.Length];
                for (int i = 0; i < buffer.Length; i++)
                {
                    buffer[i] = (byte)messageTextBlock.Text[i];
                }
                myBluetooth.SendBytes(buffer);
            }
        }
    }
}
