// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "A_Own/FresnelShield"
{
	Properties
	{
		_Globalopacity("Global opacity", Range( 0 , 1)) = 1
		_Maintexture("Main texture", 2D) = "white" {}
		_Maintextureintensity("Main texture intensity", Float) = 0
		_MainPanningspeed("Main Panning speed", Vector) = (0,0,0,0)
		[Toggle]_Invert("Invert", Range( 0 , 1)) = 0
		[HDR]_Maincolor("Main color", Color) = (0.7941176,0.1284602,0.1284602,0.666)
		[HDR]_Edgecolor("Edge color", Color) = (0.7941176,0.1284602,0.1284602,0.666)
		_Bias("Bias", Float) = 0
		_Scale("Scale", Float) = 0
		_Power("Power", Range( 0 , 5)) = 0
		_Secondarytexture("Secondary texture", 2D) = "black" {}
		_Seondarytextureintensity("Seondary texture intensity", Float) = 1
		_Secondarypanningspeed("Secondary panning speed", Vector) = (0,0,0,0)
		[HDR]_Secondarycolor("Secondary color", Color) = (0,0,0,0)
		_Distortionscale("Distortion scale", Range( 0 , 4)) = 0.04
		_Distortionspeed("Distortion speed", Range( 0 , 5)) = 1
		_Extraroughness("Extra roughness", Range( 0 , 10)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			float2 uv_texcoord;
		};

		uniform float _Extraroughness;
		uniform float _Distortionspeed;
		uniform float _Distortionscale;
		uniform float _Globalopacity;
		uniform float _Bias;
		uniform float _Scale;
		uniform float _Power;
		uniform float4 _Edgecolor;
		uniform sampler2D _Secondarytexture;
		uniform float2 _Secondarypanningspeed;
		uniform float4 _Secondarytexture_ST;
		uniform float4 _Secondarycolor;
		uniform float _Seondarytextureintensity;
		uniform float _Maintextureintensity;
		uniform float _Invert;
		uniform sampler2D _Maintexture;
		uniform float2 _MainPanningspeed;
		uniform float4 _Maintexture_ST;
		uniform float4 _Maincolor;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 ase_vertexNormal = v.normal.xyz;
			float simplePerlin2D52 = snoise( ( ( _Extraroughness * ase_vertex3Pos ) + ase_vertexNormal + ( _Time.y * _Distortionspeed ) ).xy );
			float temp_output_76_0 = ( _Distortionscale / 100.0 );
			float VertexOut74 = (( temp_output_76_0 * -1.0 ) + (simplePerlin2D52 - 0.0) * (temp_output_76_0 - ( temp_output_76_0 * -1.0 )) / (1.0 - 0.0));
			float3 temp_cast_1 = (VertexOut74).xxx;
			v.vertex.xyz += temp_cast_1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV1 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode1 = ( _Bias + _Scale * pow( 1.0 - fresnelNdotV1, _Power ) );
			float4 FresnelOut66 = ( fresnelNode1 * _Edgecolor );
			float2 uv_Secondarytexture = i.uv_texcoord * _Secondarytexture_ST.xy + _Secondarytexture_ST.zw;
			float2 panner37 = ( _Time.y * _Secondarypanningspeed + uv_Secondarytexture);
			float4 SecondaryTexOut72 = ( tex2D( _Secondarytexture, panner37 ).r * _Secondarycolor * _Seondarytextureintensity );
			float2 uv_Maintexture = i.uv_texcoord * _Maintexture_ST.xy + _Maintexture_ST.zw;
			float2 panner26 = ( _Time.y * _MainPanningspeed + uv_Maintexture);
			float3 desaturateInitialColor56 = tex2D( _Maintexture, panner26 ).rgb;
			float desaturateDot56 = dot( desaturateInitialColor56, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar56 = lerp( desaturateInitialColor56, desaturateDot56.xxx, 1.0 );
			float4 MainTexOut64 = ( _Maintextureintensity * float4( ( ( _Invert * ( 1.0 - desaturateVar56 ) ) + ( ( 1.0 - _Invert ) * desaturateVar56 ) ) , 0.0 ) * _Maincolor );
			float4 EmissionOut70 = ( FresnelOut66 + SecondaryTexOut72 + MainTexOut64 );
			o.Emission = ( _Globalopacity * EmissionOut70 ).rgb;
			float FresnelMask68 = fresnelNode1;
			o.Alpha = ( _Globalopacity * FresnelMask68 );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15800
453;92;1146;561;3667.596;857.9893;3.538225;True;False
Node;AmplifyShaderEditor.CommentaryNode;77;-3210.931,-1066.558;Float;False;2077.09;620.5684;Main texture;16;22;56;25;58;57;61;59;60;62;24;64;40;26;29;28;30;Main texture;1,0.8264706,0.5661765,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;29;-3131.567,-576.9528;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;30;-3157.773,-843.1888;Float;False;0;22;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;28;-3160.931,-712.7684;Float;False;Property;_MainPanningspeed;Main Panning speed;3;0;Create;True;0;0;False;0;0,0;0,0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;26;-2918.151,-732.5779;Float;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;22;-2682.968,-728.6262;Float;True;Property;_Maintexture;Main texture;1;0;Create;True;0;0;False;0;None;5a225669b449f104ebfe1ac897d85446;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DesaturateOpNode;56;-2392.252,-726.6635;Float;True;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;78;-3199.609,-251.256;Float;False;1475.324;601.3291;Secondary texture;9;34;36;35;37;63;39;32;38;72;Secondary texture;0.4411765,1,0.5837727,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-2400.959,-978.6775;Float;False;Property;_Invert;Invert;4;1;[Toggle];Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;35;-3047.817,44.99176;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;58;-2124.286,-880.2736;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;79;-1021.959,-1056.515;Float;False;1057.146;569.5391;Fresnel;8;1;68;19;20;21;2;3;66;Fresnel;0.4632353,0.7334687,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;34;-3149.609,-81.57729;Float;False;Property;_Secondarypanningspeed;Secondary panning speed;12;0;Create;True;0;0;False;0;0,0;0,2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;36;-3142.131,-201.256;Float;False;0;32;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;25;-2124.751,-804.6735;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-907.9467,-918.0861;Float;False;Property;_Scale;Scale;8;0;Create;True;0;0;False;0;0;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-971.959,-813.5464;Float;False;Property;_Power;Power;9;0;Create;True;0;0;False;0;0;1.22;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;-1898.269,-817.2415;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PannerNode;37;-2808.948,-120.643;Float;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-900.3204,-1006.515;Float;False;Property;_Bias;Bias;7;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-1900.869,-918.6412;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-1909.191,-1016.559;Float;False;Property;_Maintextureintensity;Main texture intensity;2;0;Create;True;0;0;False;0;0;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;63;-2600.998,235.0731;Float;False;Property;_Seondarytextureintensity;Seondary texture intensity;11;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;62;-2115.362,-652.9903;Float;False;Property;_Maincolor;Main color;5;1;[HDR];Create;True;0;0;False;0;0.7941176,0.1284602,0.1284602,0.666;0,0.7098039,1,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;2;-958.1163,-720.3439;Float;False;Property;_Edgecolor;Edge color;6;1;[HDR];Create;True;0;0;False;0;0.7941176,0.1284602,0.1284602,0.666;0,0.7098039,1,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;39;-2532.375,59.99677;Float;False;Property;_Secondarycolor;Secondary color;13;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0.2647059,0.6957404,1,0.978;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;1;-705.4872,-1000.102;Float;True;Standard;TangentNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;32;-2561.025,-146.5123;Float;True;Property;_Secondarytexture;Secondary texture;10;0;Create;True;0;0;False;0;None;e3933cb2e2577fb4ab81423186807589;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;60;-1751.82,-877.7751;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;80;-1574.316,-183.8432;Float;False;1304.961;773.6906;Vertex manipulation;14;86;87;84;74;54;52;55;76;50;45;49;53;47;48;Vertex manipulation;0.9389453,1,0.3676471,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-412.4366,-739.976;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;47;-1514.774,281.2565;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-1514.775,360.2555;Float;False;Property;_Distortionspeed;Distortion speed;15;0;Create;True;0;0;False;0;1;0.88;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-2189.449,-149.6149;Float;True;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;86;-1533.22,-118.8099;Float;False;Property;_Extraroughness;Extra roughness;16;0;Create;True;0;0;False;0;0;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-1585.586,-905.7387;Float;True;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PosVertexDataNode;87;-1526.46,-25.53629;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;72;-1992.287,-154.948;Float;False;SecondaryTexOut;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;64;-1376.841,-909.6318;Float;False;MainTexOut;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;66;-207.8127,-746.4772;Float;False;FresnelOut;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;-1184.457,86.66258;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-1503.204,465.2063;Float;False;Property;_Distortionscale;Distortion scale;14;0;Create;True;0;0;False;0;0.04;0.01;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-1226.245,300.1455;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;45;-1522.921,120.7372;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;50;-1025.649,151.3271;Float;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;76;-1223.434,472.0741;Float;False;2;0;FLOAT;0;False;1;FLOAT;100;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;65;187.3846,-574.7102;Float;False;64;MainTexOut;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;73;141.0146,-678.9474;Float;False;72;SecondaryTexOut;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;67;228.6177,-774.9464;Float;False;66;FresnelOut;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-1020.743,279.9459;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;52;-900.7266,146.4752;Float;False;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;31;421.0322,-731.0457;Float;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;70;621.0007,-734.195;Float;False;EmissionOut;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;54;-695.5218,150.5461;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;68;-437.2858,-1004.137;Float;False;FresnelMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;71;-46.47443,-90.5522;Float;False;70;EmissionOut;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;74;-516.5403,144.9342;Float;False;VertexOut;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;69;-48.15155,25.14956;Float;False;68;FresnelMask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-115.4807,-172.7427;Float;False;Property;_Globalopacity;Global opacity;0;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;185.3922,9.25548;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;206.9957,-167.6349;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;75;151.8694,113.8404;Float;False;74;VertexOut;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;399.4984,-230.9863;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;A_Own/FresnelShield;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;26;0;30;0
WireConnection;26;2;28;0
WireConnection;26;1;29;0
WireConnection;22;1;26;0
WireConnection;56;0;22;0
WireConnection;58;0;57;0
WireConnection;25;0;56;0
WireConnection;61;0;58;0
WireConnection;61;1;56;0
WireConnection;37;0;36;0
WireConnection;37;2;34;0
WireConnection;37;1;35;0
WireConnection;59;0;57;0
WireConnection;59;1;25;0
WireConnection;1;1;21;0
WireConnection;1;2;20;0
WireConnection;1;3;19;0
WireConnection;32;1;37;0
WireConnection;60;0;59;0
WireConnection;60;1;61;0
WireConnection;3;0;1;0
WireConnection;3;1;2;0
WireConnection;38;0;32;1
WireConnection;38;1;39;0
WireConnection;38;2;63;0
WireConnection;24;0;40;0
WireConnection;24;1;60;0
WireConnection;24;2;62;0
WireConnection;72;0;38;0
WireConnection;64;0;24;0
WireConnection;66;0;3;0
WireConnection;84;0;86;0
WireConnection;84;1;87;0
WireConnection;49;0;47;0
WireConnection;49;1;48;0
WireConnection;50;0;84;0
WireConnection;50;1;45;0
WireConnection;50;2;49;0
WireConnection;76;0;53;0
WireConnection;55;0;76;0
WireConnection;52;0;50;0
WireConnection;31;0;67;0
WireConnection;31;1;73;0
WireConnection;31;2;65;0
WireConnection;70;0;31;0
WireConnection;54;0;52;0
WireConnection;54;3;55;0
WireConnection;54;4;76;0
WireConnection;68;0;1;0
WireConnection;74;0;54;0
WireConnection;44;0;41;0
WireConnection;44;1;69;0
WireConnection;42;0;41;0
WireConnection;42;1;71;0
WireConnection;0;2;42;0
WireConnection;0;9;44;0
WireConnection;0;11;75;0
ASEEND*/
//CHKSM=F83E0859568BA560EBFF8FB75B4B9F392148FEAE