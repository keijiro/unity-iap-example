var skin : GUISkin;
var fontLoRes : Font;
var fontHiRes : Font;

function Start() {
	skin = Instantiate(skin) as GUISkin;
	skin.font = Screen.width < 500 ? fontLoRes : fontHiRes;
	
	StoreKit.Install("jp.radiumsoftware.iaptest");
}

function Update() {
	var coin = SecureData.GetInt("Coin");
	if (StoreKit.ConsumeProduct("coin1")) {
		SecureData.SetInt("Coin", coin + 1000);
		SecureData.Flush();
	} else if (StoreKit.ConsumeProduct("coin2")) {
		SecureData.SetInt("Coin", coin + 2500);
		SecureData.Flush();
	} else if (StoreKit.ConsumeProduct("coin3")) {
		SecureData.SetInt("Coin", coin + 4000);
		SecureData.Flush();
	} else if (StoreKit.ConsumeProduct("levelx")) {
		SecureData.SetBool("UnlockLevelX", true);
		SecureData.Flush();
	} else if (StoreKit.ConsumeProduct("levely")) {
		SecureData.SetBool("UnlockLevelY", true);
		SecureData.Flush();
	}
}

function OnGUI() {
	if (!StoreKit.isAvailable) return;
	
	var deactivated = StoreKit.isProcessing;
	
	GUI.skin = skin;
	GUI.color = Color(1, 1, 1, deactivated ? 0.2 : 1.0);
	
	var coin = SecureData.GetInt("Coin");
	var levelX = SecureData.GetBool("UnlockLevelX");
	var levelY = SecureData.GetBool("UnlockLevelY");
	
	GUILayout.BeginArea(Rect(10, 0, Screen.width - 20, Screen.height));
	GUILayout.FlexibleSpace();

	GUILayout.Label("Coins: " + coin.ToString());
	GUILayout.Label("Unlocked levels: " + (levelX ? "X" : "") + (levelY ? "Y" : ""));

	if (coin > 1234) {
		GUILayout.FlexibleSpace();
		
		if (GUILayout.Button("Use 1,234 coins") && !deactivated) {
			SecureData.SetInt("Coin", coin - 1234);
			SecureData.Flush();
		}
	}

	GUILayout.FlexibleSpace();

	GUILayout.Label("Buy coins:");

	if (GUILayout.Button("1,000 coin pack") && !deactivated) {
		StoreKit.Buy("coin1");
	}

	if (GUILayout.Button("2,500 coin pack") && !deactivated) {
		StoreKit.Buy("coin2");
	}
	
	if (GUILayout.Button("4,000 coin pack") && !deactivated) {
		StoreKit.Buy("coin3");
	}
	
	if (!levelX || !levelY) {
		GUILayout.FlexibleSpace();
	
		GUILayout.Label("Buy additional levels:");
	
		if (!levelX && GUILayout.Button("Unlock level X") && !deactivated) {
			StoreKit.Buy("levelx");
		}
	
		if (!levelY && GUILayout.Button("Unlock level Y") && !deactivated) {
			StoreKit.Buy("levely");
		}
	}

	GUILayout.FlexibleSpace();

	GUILayout.EndArea();
}
