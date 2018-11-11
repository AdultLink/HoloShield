// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AdultLink/FresnelShield"
{
	Properties
	{
		_Globalopacity("Global opacity", Range( 0 , 1)) = 1
		_Maintexture("Main texture", 2D) = "white" {}
		_Maintextureintensity("Main texture intensity", Float) = 0
		_Mainpanningspeed("Main panning speed", Vector) = (0,0,0,0)
		[Toggle]_Invertmaintexture("Invert main texture", Range( 0 , 1)) = 0
		[HDR]_Maincolor("Main color", Color) = (0.7941176,0.1284602,0.1284602,0.666)
		[HDR]_Edgecolor("Edge color", Color) = (0.7941176,0.1284602,0.1284602,0.666)
		_Bias("Bias", Float) = 0
		_Scale("Scale", Float) = 0
		_Power("Power", Range( 0 , 5)) = 0
		_Secondarytexture("Secondary texture", 2D) = "black" {}
		_Seondarytextureintensity("Seondary texture intensity", Float) = 1
		_Secondarypanningspeed("Secondary panning speed", Vector) = (0,0,0,0)
		[Toggle]_Invertsecondarytexture("Invert secondary texture", Range( 0 , 1)) = 0
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
		uniform float _Seondarytextureintensity;
		uniform float _Invertsecondarytexture;
		uniform sampler2D _Secondarytexture;
		uniform float2 _Secondarypanningspeed;
		uniform float4 _Secondarytexture_ST;
		uniform float4 _Secondarycolor;
		uniform float _Maintextureintensity;
		uniform float _Invertmaintexture;
		uniform sampler2D _Maintexture;
		uniform float2 _Mainpanningspeed;
		uniform float4 _Maintexture_ST;
		uniform float4 _Maincolor;


		float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }

		float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }

		float snoise( float3 v )
		{
			const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
			float3 i = floor( v + dot( v, C.yyy ) );
			float3 x0 = v - i + dot( i, C.xxx );
			float3 g = step( x0.yzx, x0.xyz );
			float3 l = 1.0 - g;
			float3 i1 = min( g.xyz, l.zxy );
			float3 i2 = max( g.xyz, l.zxy );
			float3 x1 = x0 - i1 + C.xxx;
			float3 x2 = x0 - i2 + C.yyy;
			float3 x3 = x0 - 0.5;
			i = mod3D289( i);
			float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
			float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
			float4 x_ = floor( j / 7.0 );
			float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
			float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 h = 1.0 - abs( x ) - abs( y );
			float4 b0 = float4( x.xy, y.xy );
			float4 b1 = float4( x.zw, y.zw );
			float4 s0 = floor( b0 ) * 2.0 + 1.0;
			float4 s1 = floor( b1 ) * 2.0 + 1.0;
			float4 sh = -step( h, 0.0 );
			float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
			float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
			float3 g0 = float3( a0.xy, h.x );
			float3 g1 = float3( a0.zw, h.y );
			float3 g2 = float3( a1.xy, h.z );
			float3 g3 = float3( a1.zw, h.w );
			float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
			g0 *= norm.x;
			g1 *= norm.y;
			g2 *= norm.z;
			g3 *= norm.w;
			float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
			m = m* m;
			m = m* m;
			float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
			return 42.0 * dot( m, px);
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 ase_vertexNormal = v.normal.xyz;
			float simplePerlin3D52 = snoise( ( ( _Extraroughness * ase_vertex3Pos ) + ase_vertexNormal + ( _Time.y * _Distortionspeed ) ) );
			float temp_output_76_0 = ( _Distortionscale / 100.0 );
			float VertexOut74 = (( temp_output_76_0 * -1.0 ) + (simplePerlin3D52 - 0.0) * (temp_output_76_0 - ( temp_output_76_0 * -1.0 )) / (1.0 - 0.0));
			float3 temp_cast_0 = (VertexOut74).xxx;
			v.vertex.xyz += temp_cast_0;
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
			float4 tex2DNode32 = tex2D( _Secondarytexture, panner37 );
			float4 SecondaryTexOut72 = ( _Seondarytextureintensity * ( ( _Invertsecondarytexture * ( 1.0 - tex2DNode32 ) ) + ( ( 1.0 - _Invertsecondarytexture ) * tex2DNode32 ) ) * _Secondarycolor );
			float2 uv_Maintexture = i.uv_texcoord * _Maintexture_ST.xy + _Maintexture_ST.zw;
			float2 panner26 = ( _Time.y * _Mainpanningspeed + uv_Maintexture);
			float3 desaturateInitialColor56 = tex2D( _Maintexture, panner26 ).rgb;
			float desaturateDot56 = dot( desaturateInitialColor56, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar56 = lerp( desaturateInitialColor56, desaturateDot56.xxx, 1.0 );
			float4 MainTexOut64 = ( _Maintextureintensity * float4( ( ( _Invertmaintexture * ( 1.0 - desaturateVar56 ) ) + ( ( 1.0 - _Invertmaintexture ) * desaturateVar56 ) ) , 0.0 ) * _Maincolor );
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
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
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
476;73;1058;571;399.2068;50.55998;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;77;-4002.266,-1303.958;Float;False;2077.09;620.5684;Main texture;16;22;56;25;58;57;61;59;60;62;24;64;40;26;29;28;30;Main texture;1,0.8264706,0.5661765,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;29;-3922.902,-814.3534;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;30;-3949.108,-1080.589;Float;False;0;22;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;78;-3996.801,-563.069;Float;False;2015.238;662.808;Secondary texture;15;93;63;39;72;38;89;92;91;90;88;32;37;35;34;36;Secondary texture;0.4411765,1,0.5837727,1;0;0
Node;AmplifyShaderEditor.Vector2Node;28;-3952.266,-950.1689;Float;False;Property;_Mainpanningspeed;Main panning speed;3;0;Create;True;0;0;False;0;0,0;0,0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;36;-3911.025,-307.9034;Float;False;0;32;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;26;-3709.486,-969.9785;Float;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;34;-3918.502,-188.2249;Float;False;Property;_Secondarypanningspeed;Secondary panning speed;12;0;Create;True;0;0;False;0;0,0;0,2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;35;-3816.71,-61.65586;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;22;-3474.303,-966.0268;Float;True;Property;_Maintexture;Main texture;1;0;Create;True;0;0;False;0;None;5a225669b449f104ebfe1ac897d85446;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;37;-3577.842,-227.2906;Float;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-3192.294,-1216.078;Float;False;Property;_Invertmaintexture;Invert main texture;4;1;[Toggle];Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;56;-3183.587,-964.0641;Float;True;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;32;-3329.918,-253.1599;Float;True;Property;_Secondarytexture;Secondary texture;10;0;Create;True;0;0;False;0;None;e3933cb2e2577fb4ab81423186807589;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;93;-3295.886,-476.6639;Float;False;Property;_Invertsecondarytexture;Invert secondary texture;13;1;[Toggle];Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;58;-2915.621,-1117.674;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;89;-3019.396,-381.9348;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;88;-3019.861,-306.3347;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;25;-2916.086,-1042.074;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;79;-1021.959,-1056.515;Float;False;1057.146;569.5391;Fresnel;8;1;68;19;20;21;2;3;66;Fresnel;0.4632353,0.7334687,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-971.959,-813.5464;Float;False;Property;_Power;Power;9;0;Create;True;0;0;False;0;0;1.22;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-907.9467,-918.0861;Float;False;Property;_Scale;Scale;8;0;Create;True;0;0;False;0;0;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-900.3204,-1006.515;Float;False;Property;_Bias;Bias;7;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;91;-2793.379,-318.9028;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;-2795.979,-420.3029;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;-2689.604,-1054.642;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-2692.204,-1156.042;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-2700.526,-1253.959;Float;False;Property;_Maintextureintensity;Main texture intensity;2;0;Create;True;0;0;False;0;0;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;2;-958.1163,-720.3439;Float;False;Property;_Edgecolor;Edge color;6;1;[HDR];Create;True;0;0;False;0;0.7941176,0.1284602,0.1284602,0.666;0,0.7098039,1,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;80;-1574.316,-183.8432;Float;False;1304.961;773.6906;Vertex manipulation;14;86;87;84;74;54;52;55;76;50;45;49;53;47;48;Vertex manipulation;0.9389453,1,0.3676471,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;92;-2646.93,-379.4368;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;60;-2543.155,-1115.176;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;62;-2906.697,-890.3909;Float;False;Property;_Maincolor;Main color;5;1;[HDR];Create;True;0;0;False;0;0.7941176,0.1284602,0.1284602,0.666;0,0.7098039,1,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;63;-2816.414,-502.4873;Float;False;Property;_Seondarytextureintensity;Seondary texture intensity;11;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;1;-705.4872,-1000.102;Float;True;Standard;TangentNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;39;-2804.878,-212.8054;Float;False;Property;_Secondarycolor;Secondary color;14;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0.2647059,0.6957404,1,0.978;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;47;-1514.774,281.2565;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;86;-1533.22,-118.8099;Float;False;Property;_Extraroughness;Extra roughness;17;0;Create;True;0;0;False;0;0;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;87;-1526.46,-25.53629;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;48;-1514.775,360.2555;Float;False;Property;_Distortionspeed;Distortion speed;16;0;Create;True;0;0;False;0;1;0.88;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-2488.755,-385.2537;Float;True;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-412.4366,-739.976;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-2376.921,-1143.139;Float;True;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;66;-207.8127,-746.4772;Float;False;FresnelOut;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;64;-2168.176,-1147.032;Float;False;MainTexOut;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;-1184.457,86.66258;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-1503.204,465.2063;Float;False;Property;_Distortionscale;Distortion scale;15;0;Create;True;0;0;False;0;0.04;0.01;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-1226.245,300.1455;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;45;-1522.921,120.7372;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;72;-2275.476,-390.5868;Float;False;SecondaryTexOut;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;50;-1025.649,151.3271;Float;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;76;-1223.434,472.0741;Float;False;2;0;FLOAT;0;False;1;FLOAT;100;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;65;187.3846,-574.7102;Float;False;64;MainTexOut;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;67;228.6177,-774.9464;Float;False;66;FresnelOut;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;73;141.0146,-678.9474;Float;False;72;SecondaryTexOut;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;52;-900.7266,146.4752;Float;False;Simplex3D;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;31;421.0322,-731.0457;Float;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-1020.743,279.9459;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;54;-695.5218,150.5461;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;70;621.0007,-734.195;Float;False;EmissionOut;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;68;-437.2858,-1004.137;Float;False;FresnelMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;71;-46.47443,-90.5522;Float;False;70;EmissionOut;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;74;-516.5403,144.9342;Float;False;VertexOut;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-115.4807,-172.7427;Float;False;Property;_Globalopacity;Global opacity;0;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;69;-48.15155,25.14956;Float;False;68;FresnelMask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;94;-23.34181,222.7135;Float;False;Property;_Test;Test;18;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;75;-28.1306,140.8404;Float;False;74;VertexOut;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;99;277.5776,277.8896;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;206.9957,-167.6349;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;102;120.7932,226.44;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;185.3922,9.25548;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;98;29.57764,331.8896;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;399.4984,-230.9863;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;AdultLink/FresnelShield;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;26;0;30;0
WireConnection;26;2;28;0
WireConnection;26;1;29;0
WireConnection;22;1;26;0
WireConnection;37;0;36;0
WireConnection;37;2;34;0
WireConnection;37;1;35;0
WireConnection;56;0;22;0
WireConnection;32;1;37;0
WireConnection;58;0;57;0
WireConnection;89;0;93;0
WireConnection;88;0;32;0
WireConnection;25;0;56;0
WireConnection;91;0;89;0
WireConnection;91;1;32;0
WireConnection;90;0;93;0
WireConnection;90;1;88;0
WireConnection;61;0;58;0
WireConnection;61;1;56;0
WireConnection;59;0;57;0
WireConnection;59;1;25;0
WireConnection;92;0;90;0
WireConnection;92;1;91;0
WireConnection;60;0;59;0
WireConnection;60;1;61;0
WireConnection;1;1;21;0
WireConnection;1;2;20;0
WireConnection;1;3;19;0
WireConnection;38;0;63;0
WireConnection;38;1;92;0
WireConnection;38;2;39;0
WireConnection;3;0;1;0
WireConnection;3;1;2;0
WireConnection;24;0;40;0
WireConnection;24;1;60;0
WireConnection;24;2;62;0
WireConnection;66;0;3;0
WireConnection;64;0;24;0
WireConnection;84;0;86;0
WireConnection;84;1;87;0
WireConnection;49;0;47;0
WireConnection;49;1;48;0
WireConnection;72;0;38;0
WireConnection;50;0;84;0
WireConnection;50;1;45;0
WireConnection;50;2;49;0
WireConnection;76;0;53;0
WireConnection;52;0;50;0
WireConnection;31;0;67;0
WireConnection;31;1;73;0
WireConnection;31;2;65;0
WireConnection;55;0;76;0
WireConnection;54;0;52;0
WireConnection;54;3;55;0
WireConnection;54;4;76;0
WireConnection;70;0;31;0
WireConnection;68;0;1;0
WireConnection;74;0;54;0
WireConnection;99;0;102;0
WireConnection;99;1;98;0
WireConnection;42;0;41;0
WireConnection;42;1;71;0
WireConnection;102;0;94;0
WireConnection;44;0;41;0
WireConnection;44;1;69;0
WireConnection;0;2;42;0
WireConnection;0;9;44;0
WireConnection;0;11;75;0
ASEEND*/
//CHKSM=B2376D937BAB30653CFA30AE10DEF919642F6CF7