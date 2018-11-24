using UnityEngine;
using UnityEditor;
 
namespace AdultLink
{
public class HoloShieldEditor : ShaderGUI
{
	MaterialEditor _materialEditor;
	MaterialProperty[] _properties;

	//TESSELLATION SETTINGS
	private MaterialProperty _TessValue = null;
	private MaterialProperty _TessMin = null;
	private MaterialProperty _TessMax  = null;
	private MaterialProperty _TessPhongStrength  = null;

	//TEXTURES SETTINGS
		//MAIN TEXTURE
	private MaterialProperty _Maintexture  = null;
	private MaterialProperty _Maintextureintensity  = null;
	private MaterialProperty _Mainpanningspeed = null;
	private MaterialProperty _Invertmaintexture = null;
	private MaterialProperty _Maincolor = null;
		//SECONDARY TEXTURE
	private MaterialProperty _Secondarytexture  = null;
	private MaterialProperty _Secondarytextureintensity  = null;
	private MaterialProperty _Secondarypanningspeed = null;
	private MaterialProperty _Invertsecondarytexture = null;
	private MaterialProperty _Secondarycolor = null;
	
	//FRESNEL SETTINGS
	private MaterialProperty _Globalopacity = null;
	private MaterialProperty _Edgecolor = null;
	private MaterialProperty _Bias = null;
	private MaterialProperty _Scale = null;
	private MaterialProperty _Power = null;
	private MaterialProperty _Innerfresnelintensity = null;
	private MaterialProperty _Outerfresnelintensity = null;
	
	//DISTORTION
	private MaterialProperty _Enabledistortion = null;
	private MaterialProperty _Distortionscale = null;
	private MaterialProperty _Distortionspeed = null;
	private MaterialProperty _Extraroughness = null;

	//PULSATION
	private MaterialProperty _Enablepulsation = null;
	private MaterialProperty _Pulseamplitude = null;
	private MaterialProperty _Pulsefrequency = null;
	private MaterialProperty _Pulsephase = null;
	private MaterialProperty _Pulseoffset = null;

	//NOISE
	private MaterialProperty _Enablenoise = null;
	private MaterialProperty _Noisescale = null;
	private MaterialProperty _Noisespeed = null;
	private MaterialProperty _Sharpennoise = null;
	

	//SWITCHES
	protected static bool ShowTextureSettings = true;
	protected static bool ShowTessellationSettings = true;
	protected static bool ShowFresnelSettings = true;
	protected static bool ShowDistortionSettings = true;
	protected static bool ShowPulsationSettings = true;
	protected static bool ShowNoiseSettings = true;
 	
	public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
    {
		_properties = properties;
		_materialEditor = materialEditor;
		EditorGUI.BeginChangeCheck();
		DrawGUI();
	}

	void GetProperties() {

		//TESSELLATION
		_TessValue = FindProperty("_TessValue", _properties);
		_TessMin = FindProperty("_TessMin", _properties);
		_TessMax = FindProperty("_TessMax", _properties);
		_TessPhongStrength = FindProperty("_TessPhongStrength", _properties);

		//TEXTURE SETTINGS
		//MAIN TEXTURE
		_Maintexture = FindProperty("_Maintexture", _properties);
		_Maintextureintensity = FindProperty("_Maintextureintensity", _properties);
		_Mainpanningspeed = FindProperty("_Mainpanningspeed", _properties);
		_Invertmaintexture = FindProperty("_Invertmaintexture", _properties);
		_Maincolor = FindProperty("_Maincolor", _properties);
		//SECONDARY TEXTURE
		_Secondarytexture = FindProperty("_Secondarytexture", _properties);
		_Secondarytextureintensity = FindProperty("_Secondarytextureintensity", _properties);
		_Secondarypanningspeed = FindProperty("_Secondarypanningspeed", _properties);
		_Invertsecondarytexture = FindProperty("_Invertsecondarytexture", _properties);
		_Secondarycolor = FindProperty("_Secondarycolor", _properties);

		//FRESNEL SETTINGS
		_Globalopacity = FindProperty("_Globalopacity", _properties);
		_Edgecolor = FindProperty("_Edgecolor", _properties);
		_Bias = FindProperty("_Bias", _properties);
		_Scale = FindProperty("_Scale", _properties);
		_Power = FindProperty("_Power", _properties);
		_Innerfresnelintensity = FindProperty("_Innerfresnelintensity", _properties);
		_Outerfresnelintensity = FindProperty("_Outerfresnelintensity", _properties);

		//DISTORTION SETTINGS
		_Enabledistortion = FindProperty("_Enabledistortion", _properties);
		_Distortionscale = FindProperty("_Distortionscale", _properties);
		_Distortionspeed = FindProperty("_Distortionspeed", _properties);
		_Extraroughness = FindProperty("_Extraroughness", _properties);

		//PULSATION SETTINGS
		_Enablepulsation = FindProperty("_Enablepulsation", _properties);
		_Pulseamplitude = FindProperty("_Pulseamplitude", _properties);
		_Pulsefrequency = FindProperty("_Pulsefrequency", _properties);
		_Pulsephase = FindProperty("_Pulsephase", _properties);
		_Pulseoffset = FindProperty("_Pulseoffset", _properties);
		
		//NOISE SETTINGS
		_Enablenoise = FindProperty("_Enablenoise", _properties);
		_Noisescale = FindProperty("_Noisescale", _properties);
		_Noisespeed = FindProperty("_Noisespeed", _properties);
		_Sharpennoise = FindProperty("_Sharpennoise", _properties);

		
	}

	static Texture2D bannerTexture = null;
    static GUIStyle title = null;
    static GUIStyle linkStyle = null;
    static string repoURL = "https://github.com/adultlink/holoshield";

	void DrawBanner()
    {
        if (bannerTexture == null)
            bannerTexture = Resources.Load<Texture2D>("HoloshieldBanner");

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
            EditorGUI.LabelField(rect, "HoloShield", title);

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
		ShowFresnelSettings = EditorGUILayout.Foldout(ShowFresnelSettings, "Fresnel");
		if (ShowFresnelSettings){
			DrawFresnelSettings();
		}
		endFoldout();

		startFoldout();
		ShowTextureSettings = EditorGUILayout.Foldout(ShowTextureSettings, "Textures");
		if (ShowTextureSettings){
			DrawTextureSettings();
		}
		endFoldout();
		startFoldout();
		ShowNoiseSettings = EditorGUILayout.Foldout(ShowNoiseSettings, "Noise");
		if (ShowNoiseSettings){
			DrawNoiseSettings();
		}
		endFoldout();

		startFoldout();
		ShowDistortionSettings = EditorGUILayout.Foldout(ShowDistortionSettings, "Distortion");
		if (ShowDistortionSettings){
			DrawDistortionSettings();
		}
		endFoldout();

		startFoldout();
		ShowPulsationSettings = EditorGUILayout.Foldout(ShowPulsationSettings, "Pulsation");
		if (ShowPulsationSettings){
			DrawPulsationSettings();
		}
		endFoldout();

		startFoldout();
		ShowTessellationSettings = EditorGUILayout.Foldout(ShowTessellationSettings, "Tessellation");
		if (ShowTessellationSettings){
			DrawTessellationSettings();
		}
		endFoldout();

    }

	void DrawTextureSettings() {
		_materialEditor.SetDefaultGUIWidths();
		EditorGUILayout.Space();
		EditorGUILayout.LabelField("Main texture", EditorStyles.boldLabel);
		_materialEditor.ShaderProperty(_Maintextureintensity, "Intensity");
		_materialEditor.ShaderProperty(_Maintexture, "Texture");
		_materialEditor.ShaderProperty(_Maincolor, "Tint");
		_materialEditor.ShaderProperty(_Mainpanningspeed, "Panning Speed");
		_materialEditor.ShaderProperty(_Invertmaintexture, "Invert");
		DrawGUILine(Color.gray);
		EditorGUILayout.Space();
		EditorGUILayout.LabelField("Secondary texture", EditorStyles.boldLabel);
		_materialEditor.ShaderProperty(_Secondarytextureintensity, "Intensity");
		_materialEditor.ShaderProperty(_Secondarytexture, "Texture");
		_materialEditor.ShaderProperty(_Secondarycolor, "Tint");
		_materialEditor.ShaderProperty(_Secondarypanningspeed, "Panning Speed");
		_materialEditor.ShaderProperty(_Invertsecondarytexture, "Invert");
		EditorGUILayout.Space();

	}

	void DrawFresnelSettings() {
		_materialEditor.SetDefaultGUIWidths();
		EditorGUILayout.Space();
		_materialEditor.ShaderProperty(_Globalopacity, "Global Opacity");
		DrawGUILine(Color.gray);
		EditorGUILayout.Space();
		_materialEditor.ShaderProperty(_Innerfresnelintensity, "Inner Opacity");
		_materialEditor.ShaderProperty(_Outerfresnelintensity, "Edge Opacity");
		_materialEditor.ShaderProperty(_Edgecolor, "Color");
		_materialEditor.ShaderProperty(_Bias, "Bias");
		_materialEditor.ShaderProperty(_Scale, "Scale");
		_materialEditor.ShaderProperty(_Power, "Power");
		EditorGUILayout.Space();
	}

	void DrawTessellationSettings() {
		_materialEditor.SetDefaultGUIWidths();
		_materialEditor.ShaderProperty(_TessValue, "Max Tessellation");
		_materialEditor.ShaderProperty(_TessMin, "Tess Min Distance");
		_materialEditor.ShaderProperty(_TessMax, "Tess Max Distance");
		_materialEditor.ShaderProperty(_TessPhongStrength, "Phong Tess strength");
		EditorGUILayout.Space();
	}

	void DrawDistortionSettings() {
		_materialEditor.SetDefaultGUIWidths();
		_materialEditor.ShaderProperty(_Enabledistortion, "Enable");
		DrawGUILine(Color.gray);
		EditorGUILayout.Space();
		_materialEditor.ShaderProperty(_Distortionscale, "Scale");
		_materialEditor.ShaderProperty(_Distortionspeed, "Speed");
		_materialEditor.ShaderProperty(_Extraroughness, "Extra Roughness");
		EditorGUILayout.Space();
	}

	void DrawPulsationSettings() {
		_materialEditor.SetDefaultGUIWidths();
		_materialEditor.ShaderProperty(_Enablepulsation, "Enable");
		DrawGUILine(Color.gray);
		EditorGUILayout.Space();
		_materialEditor.ShaderProperty(_Pulseamplitude, "Amplitude");
		_materialEditor.ShaderProperty(_Pulseoffset, "Offset");
		_materialEditor.ShaderProperty(_Pulsefrequency, "Frequency");
		_materialEditor.ShaderProperty(_Pulsephase, "Phase");
		EditorGUILayout.Space();
	}

	void DrawNoiseSettings() {
		_materialEditor.SetDefaultGUIWidths();
		_materialEditor.ShaderProperty(_Enablenoise, "Enable");
		DrawGUILine(Color.gray);
		EditorGUILayout.Space();
		_materialEditor.ShaderProperty(_Noisescale, "Scale");
		_materialEditor.ShaderProperty(_Noisespeed, "Speed");
		_materialEditor.ShaderProperty(_Sharpennoise, "Sharpen");
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