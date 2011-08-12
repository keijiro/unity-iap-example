using UnityEngine;
using System.Collections;
using System.Runtime.InteropServices;

public static class SecureData {

	public static void SetBool(string key, bool value) {
		#if UNITY_IPHONE && !UNITY_EDITOR
			_SecureDataSetBool(key, value);
		#else
			PlayerPrefs.SetInt(key, value ? 1 : 0);
		#endif
	}
	public static void SetInt(string key, int value) {
		#if UNITY_IPHONE && !UNITY_EDITOR
			_SecureDataSetInt(key, value);
		#else
			PlayerPrefs.SetInt(key, value);
		#endif
	}
	public static void SetFloat(string key, float value) {
		#if UNITY_IPHONE && !UNITY_EDITOR
			_SecureDataSetFloat(key, value);
		#else
			PlayerPrefs.SetFloat(key, value);
		#endif
	}
	public static void SetString(string key, string value) {
		#if UNITY_IPHONE && !UNITY_EDITOR
			_SecureDataSetString(key, value);
		#else
			PlayerPrefs.SetString(key, value);
		#endif
	}

	public static bool GetBool(string key) {
		#if UNITY_IPHONE && !UNITY_EDITOR
			return _SecureDataGetBool(key);
		#else
			return PlayerPrefs.GetInt(key) != 0;
		#endif
	}
	public static int GetInt(string key) {
		#if UNITY_IPHONE && !UNITY_EDITOR
			return _SecureDataGetInt(key);
		#else
			return PlayerPrefs.GetInt(key);
		#endif
	}
	public static float GetFloat(string key) {
		#if UNITY_IPHONE && !UNITY_EDITOR
			return _SecureDataGetFloat(key);
		#else
			return PlayerPrefs.GetFloat(key);
		#endif
	}
	public static string GetString(string key) {
		#if UNITY_IPHONE && !UNITY_EDITOR
			return _SecureDataGetString(key);
		#else
			return PlayerPrefs.GetString(key);
		#endif
	}

	public static void Flush() {
		#if UNITY_IPHONE && !UNITY_EDITOR
			_SecureDataFlush();
		#else
			PlayerPrefs.Save();
		#endif
	}

	#if UNITY_IPHONE

	[DllImport ("__Internal")]
	private static extern void _SecureDataSetBool(string key, bool value);
	[DllImport ("__Internal")]
	private static extern void _SecureDataSetInt(string key, int value);
	[DllImport ("__Internal")]
	private static extern void _SecureDataSetFloat(string key, float value);
	[DllImport ("__Internal")]
	private static extern void _SecureDataSetString(string key, string value);

	[DllImport ("__Internal")]
	private static extern bool _SecureDataGetBool(string key);
	[DllImport ("__Internal")]
	private static extern int _SecureDataGetInt(string key);
	[DllImport ("__Internal")]
	private static extern float _SecureDataGetFloat(string key);
	[DllImport ("__Internal")]
	private static extern string _SecureDataGetString(string key);

	[DllImport ("__Internal")]
	private static extern void _SecureDataFlush();

	#endif
}

