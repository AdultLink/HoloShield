using UnityEngine;
using UnityEditor;
 
namespace AdultLink
{
public class RimlightEditor : ShaderGUI
{
	MaterialEditor _materialEditor;
	MaterialProperty[] _properties;

	//RIMLIGHT SETTINGS
	private MaterialProperty _Enable_rimlight = null;
	private MaterialProperty _Rimlight_color = null;
	private MaterialProperty _Rimlight_power  = null;
	private MaterialProperty _Rimlight_scale  = null;
	private MaterialProperty _Rimlight_bias  = null;
	private MaterialProperty _Rimlight_opacity  = null;
	private MaterialProperty _Pulsate = null;
	private MaterialProperty _Frequency = null;
	private MaterialProperty _Addnoise = null;
	private MaterialProperty _Noisescale = null;
	private MaterialProperty _Noisespeed = null;
	
	//TEXTURE SETTINGS
	private MaterialProperty _Maintiling = null;
	private MaterialProperty _Mainoffset = null;
		//ALBEDO
	private MaterialProperty _Albedo = null;
	private MaterialProperty _Albedo_color = null;
		//NORMAL
	private MaterialProperty _Normal = null;
		//EMISSION
	private MaterialProperty _Enableemission = null;
	private MaterialProperty _Emission = null;
	private MaterialProperty _Emission_color = null;

	private MaterialProperty _Specular = null;
	private MaterialProperty _Smoothness = null;
	private MaterialProperty _Occlusion = null;

	//SWITCHES
	protected static bool ShowTextureSettings = true;
	protected static bool ShowRimlightSettings = true;
 	
	public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
    {
		_properties = properties;
		_materialEditor = materialEditor;
		EditorGUI.BeginChangeCheck();
		DrawGUI();
	}

	void GetProperties() {

		//RIMLIGHT SETTINGS
		_Enable_rimlight = FindProperty("_Enablerimlight", _properties);
		_Rimlight_color = FindProperty("_Rimlightcolor", _properties);
		_Rimlight_power = FindProperty("_Rimlightpower", _properties);
		_Rimlight_scale = FindProperty("_Rimlightscale", _properties);
		_Rimlight_bias = FindProperty("_Rimlightbias", _properties);
		_Rimlight_opacity = FindProperty("_Rimlightopacity", _properties);

		_Pulsate = FindProperty("_Pulsate", _properties);
		_Frequency = FindProperty("_Frequency", _properties);

		_Addnoise = FindProperty("_Addnoise", _properties);
		_Noisescale = FindProperty("_Noisescale", _properties);
		_Noisespeed = FindProperty("_Noisespeed", _properties);

		//TEXTURE SETTINGS
		_Maintiling = FindProperty("_Maintiling", _properties);
		_Mainoffset = FindProperty("_Mainoffset", _properties);
			//ALBEDO
		_Albedo = FindProperty("_Albedo", _properties);
		_Albedo_color = FindProperty("_Albedotintcolor", _properties);
			//NORMAL
		_Normal = FindProperty("_Normal", _properties);
			//EMISSION
		_Enableemission = FindProperty("_Enableemission", _properties);
		_Emission = FindProperty("_Emission", _properties);
		_Emission_color = FindProperty("_Emissiontintcolor", _properties);
			//SPEC
		_Specular = FindProperty("_Specular", _properties);
		_Smoothness = FindProperty("_Smoothness", _properties);
			//OCCLUSION
		_Occlusion = FindProperty("_Occlusion", _properties);
	}

	static Texture2D bannerTexture = null;
    static GUIStyle title = null;
    static GUIStyle linkStyle = null;
    static string repoURL = "https://github.com/adultlink/rimlight";

	void DrawBanner()
    {
        if (bannerTexture == null)
            bannerTexture = Resources.Load<Texture2D>("RimlightBanner");

        if (title == null)
        {
            title = new GUIStyle();
            title.fontSize = 20;
            title.alignment = TextAnchor.MiddleCenter;
            title.normal.textColor = new Color(1f, 1f, 1f);
        }
		

        if (linkStyle == null) linkStyle = new GUIStyle();

        if (bannerTexture != null)
        {
            GUILayout.Space(4);
            var rect = GUILayoutUtility.GetRect(0, int.MaxValue, 60, 60);
            EditorGUI.DrawPreviewTexture(rect, bannerTexture, null, ScaleMode.ScaleAndCrop);
            //
            EditorGUI.LabelField(rect, "Rimlight", title);

            if (GUI.Button(rect, "", linkStyle)) {
                Application.OpenURL(repoURL);
            }
            GUILayout.Space(4);
        }
    }

	void DrawGUI() {
		GetProperties();
		DrawBanner();

		startFoldout();
		ShowTextureSettings = EditorGUILayout.Foldout(ShowTextureSettings, "Textures");
		if (ShowTextureSettings){
			DrawTextureSettings();
		}
		endFoldout();

		startFoldout();
		ShowRimlightSettings = EditorGUILayout.Foldout(ShowRimlightSettings, "Rim light");
		if (ShowRimlightSettings){
			DrawRimlightSettings();
		}
		endFoldout();

    }

	void DrawTextureSettings() {
		EditorGUILayout.Space();
		_materialEditor.ShaderProperty(_Maintiling, "Tiling");
		_materialEditor.ShaderProperty(_Mainoffset, "Offset");
		EditorGUILayout.Space();
		_materialEditor.TexturePropertySingleLine(new GUIContent("Albedo"), _Albedo);
		_materialEditor.ShaderProperty(_Albedo_color, "Tint color");
		EditorGUILayout.Space();
		_materialEditor.TexturePropertySingleLine(new GUIContent("Normal"), _Normal);
		EditorGUILayout.Space();
		_materialEditor.ShaderProperty(_Enableemission, "Enable emission");
		_materialEditor.TexturePropertySingleLine(new GUIContent("Emission"), _Emission);
		_materialEditor.ShaderProperty(_Emission_color, "Tint color");
		EditorGUILayout.Space();
		_materialEditor.TexturePropertySingleLine(new GUIContent("Specular"), _Specular);
		_materialEditor.ShaderProperty(_Smoothness, "Smoothness");
		EditorGUILayout.Space();
		_materialEditor.TexturePropertySingleLine(new GUIContent("Occlusion"), _Occlusion);
		EditorGUILayout.Space();

	}

	void DrawRimlightSettings() {
		_materialEditor.SetDefaultGUIWidths();
		EditorGUILayout.Space();
		_materialEditor.ShaderProperty(_Enable_rimlight, "Enable");
		_materialEditor.ShaderProperty(_Rimlight_color, "Color");
		_materialEditor.ShaderProperty(_Rimlight_power, "Power");
		_materialEditor.ShaderProperty(_Rimlight_scale, "Scale");
		_materialEditor.ShaderProperty(_Rimlight_bias, "Bias");
		_materialEditor.ShaderProperty(_Rimlight_opacity, "Opacity");

		EditorGUILayout.Space();

		//PULSATE
		EditorGUILayout.BeginVertical(EditorStyles.helpBox);
		EditorGUILayout.LabelField("Pulsate", EditorStyles.boldLabel);
		DrawGUILine(Color.gray);
		_materialEditor.ShaderProperty(_Pulsate, "Enable");
		_materialEditor.ShaderProperty(_Frequency, "Frequency");
		EditorGUILayout.EndVertical();

		EditorGUILayout.Space();

		//NOISE
		EditorGUILayout.BeginVertical(EditorStyles.helpBox);
		EditorGUILayout.LabelField("Noise", EditorStyles.boldLabel);
		DrawGUILine(Color.gray);
		_materialEditor.ShaderProperty(_Addnoise, "Enable");
		_materialEditor.ShaderProperty(_Noisescale, "Granularity");
		_materialEditor.ShaderProperty(_Noisespeed, "Speed");
		EditorGUILayout.EndVertical();
		EditorGUILayout.Space();
	}
	
	void startFoldout() {
		EditorGUILayout.BeginVertical(EditorStyles.helpBox);
		EditorGUI.indentLevel++;
	}

	void endFoldout() {
		EditorGUI.indentLevel--;
		EditorGUILayout.EndVertical();
	}

	void DrawGUILine(Color color, int i_height = 1) {

       Rect rect = EditorGUILayout.GetControlRect(false, i_height );
       rect.height = i_height;
       EditorGUI.DrawRect(rect, color);

   }

}
}