using UnityEngine;
using System.Collections;
using System.Runtime.InteropServices;

public static class StoreKit {
	
	static string productIdPrefix_;
	
	public static bool isAvailable {
		get {
			#if UNITY_IPHONE && !UNITY_EDITOR
				return _StoreKitIsAvailable();
			#else
				return true;
			#endif
		}
	}

	public static bool isProcessing {
		get {
			#if UNITY_IPHONE && !UNITY_EDITOR
				return _StoreKitIsProcessing();
			#else
				return false;
			#endif
		}
	}
	
	static string GetPrefKey(string productName) {
		return productIdPrefix_ + "." + productName;
	}
	
	public static bool HasProduct(string productName) {
		return PlayerPrefs.GetInt(GetPrefKey(productName)) > 0;
	}
	
	public static bool ConsumeProduct(string productName) {
		string key = GetPrefKey(productName);
		int current = PlayerPrefs.GetInt(key);
		if (current > 0) {
			PlayerPrefs.SetInt(key, current - 1);
			PlayerPrefs.Save();
			return true;
		} else {
			return false;
		}
	}

	public static void Install(string productIdPrefix) {
		productIdPrefix_ = productIdPrefix;
		#if UNITY_IPHONE && !UNITY_EDITOR
			_StoreKitInstall(productIdPrefix);
		#endif
	}
	
	public static void Buy(string productName) {
		#if UNITY_IPHONE && !UNITY_EDITOR
			_StoreKitBuy(productName);
		#else
			string id = productIdPrefix_ + "." + productName;
			PlayerPrefs.SetInt(id, PlayerPrefs.GetInt(id) + 1);
		#endif
	}
		
	#if UNITY_IPHONE

	[DllImport ("__Internal")]
	private static extern void _StoreKitInstall(string productIdPrefix);
	[DllImport ("__Internal")]
	private static extern bool _StoreKitIsAvailable();
	[DllImport ("__Internal")]
	private static extern void _StoreKitBuy(string productName);
	[DllImport ("__Internal")]
	private static extern bool _StoreKitIsProcessing();

	#endif
}

