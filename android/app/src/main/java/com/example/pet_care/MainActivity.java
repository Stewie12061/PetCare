package com.example.pet_care;
import android.Manifest;
import android.content.pm.PackageManager;
import android.os.Bundle;
import io.flutter.embedding.android.FlutterFragmentActivity;
//import io.flutter.embedding.android.FlutterActivity;
import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
public class MainActivity extends FlutterFragmentActivity {
    private static final int REQUEST_PERMISSIONS_CODE = 1001;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (checkPermissions()) {
            // Permissions already granted, proceed with your logic
        } else {
            requestPermissions();
        }
    }

    private boolean checkPermissions() {
        return ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED
                && ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION) == PackageManager.PERMISSION_GRANTED;
    }

    private void requestPermissions() {
        ActivityCompat.requestPermissions(
                this,
                new String[]{
                        Manifest.permission.ACCESS_FINE_LOCATION,
                        Manifest.permission.ACCESS_COARSE_LOCATION
                },
                REQUEST_PERMISSIONS_CODE
        );
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == REQUEST_PERMISSIONS_CODE) {
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                // Permissions granted, proceed with your logic
            } else {
                // Permissions denied, handle accordingly
            }
        }
    }

}
