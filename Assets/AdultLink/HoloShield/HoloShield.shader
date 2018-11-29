// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AdultLink/HoloShield"
{
	Properties
	{
		_Globalopacity("Global opacity", Range( 0 , 1)) = 1
		_Maintexture("Main texture", 2D) = "black" {}
		_Maintextureintensity("Main texture intensity", Float) = 1
		_Mainpanningspeed("Main panning speed", Vector) = (0,0,0,0)
		[Toggle]_Invertmaintexture("Invert main texture", Range( 0 , 1)) = 0
		[HDR]_Maincolor("Main color", Color) = (0.7941176,0.1284602,0.1284602,0.666)
		_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 1
		_TessMin( "Tess Min Distance", Float ) = 10
		_TessMax( "Tess Max Distance", Float ) = 25
		_TessPhongStrength( "Phong Tess Strength", Range( 0, 1 ) ) = 0.5
		[HDR]_Edgecolor("Edge color", Color) = (0.7941176,0.1284602,0.1284602,0.666)
		_Bias("Bias", Float) = 0
		_Scale("Scale", Float) = 1
		_Power("Power", Range( 0 , 5)) = 2
		_Innerfresnelintensity("Inner fresnel intensity", Range( 0 , 1)) = 0
		_Outerfresnelintensity("Outer fresnel intensity", Range( 0 , 1)) = 1
		_Secondarytexture("Secondary texture", 2D) = "black" {}
		_Secondarytextureintensity("Secondary texture intensity", Float) = 1
		_Secondarypanningspeed("Secondary panning speed", Vector) = (0,0,0,0)
		[Toggle]_Invertsecondarytexture("Invert secondary texture", Range( 0 , 1)) = 0
		[HDR]_Secondarycolor("Secondary color", Color) = (0,0,0,0)
		[Toggle]_Enabledistortion("Enable distortion", Range( 0 , 1)) = 0
		_Distortionscale("Distortion scale", Range( 0 , 10)) = 1
		_Distortionspeed("Distortion speed", Range( 0 , 5)) = 1
		_Extraroughness("Extra roughness", Range( 0 , 10)) = 0
		[Toggle]_Enablepulsation("Enable pulsation", Range( 0 , 1)) = 0
		_Pulsephase("Pulse phase", Float) = 0
		_Pulsefrequency("Pulse frequency", Float) = 3
		_Pulseamplitude("Pulse amplitude", Float) = 1
		_Pulseoffset("Pulse offset", Float) = 0
		[Toggle]_Enablenoise("Enable noise", Range( 0 , 1)) = 0
		_Sharpennoise("Sharpen noise", Range( 0 , 1)) = 0
		_Noisescale("Noise scale", Float) = 50
		_Noisespeed("Noise speed", Vector) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			float2 uv_texcoord;
		};

		uniform float _Enabledistortion;
		uniform float _Extraroughness;
		uniform float _Distortionspeed;
		uniform float _Distortionscale;
		uniform float _Enablepulsation;
		uniform float _Pulsefrequency;
		uniform float _Pulsephase;
		uniform float _Pulseamplitude;
		uniform float _Pulseoffset;
		uniform float _Globalopacity;
		uniform float _Outerfresnelintensity;
		uniform float _Bias;
		uniform float _Scale;
		uniform float _Power;
		uniform float _Innerfresnelintensity;
		uniform float4 _Edgecolor;
		uniform float3 _Noisespeed;
		uniform float _Noisescale;
		uniform float _Enablenoise;
		uniform float _Sharpennoise;
		uniform float _Secondarytextureintensity;
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
		uniform float _TessValue;
		uniform float _TessMin;
		uniform float _TessMax;
		uniform float _TessPhongStrength;


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


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityDistanceBasedTess( v0.vertex, v1.vertex, v2.vertex, _TessMin, _TessMax, _TessValue );
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float3 ase_vertexNormal = v.normal.xyz;
			float3 ase_vertex3Pos = v.vertex.xyz;
			float simplePerlin3D52 = snoise( ( ( _Extraroughness * ase_vertex3Pos ) + ase_vertexNormal + ( _Distortionspeed * _Time.y ) ) );
			float temp_output_76_0 = ( _Distortionscale / 100.0 );
			float3 VertexOut74 = ( ( _Enabledistortion * ( ase_vertexNormal * (( temp_output_76_0 * -1.0 ) + (simplePerlin3D52 - 0.0) * (temp_output_76_0 - ( temp_output_76_0 * -1.0 )) / (1.0 - 0.0)) ) ) + ( _Enablepulsation * ( ase_vertexNormal * (sin( (_Time.y*_Pulsefrequency + _Pulsephase) )*( _Pulseamplitude / 10.0 ) + _Pulseoffset) ) ) );
			v.vertex.xyz += VertexOut74;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV1 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode1 = ( _Bias + _Scale * pow( 1.0 - fresnelNdotV1, _Power ) );
			float clampResult170 = clamp( ( ( _Outerfresnelintensity * fresnelNode1 ) + ( ( 1.0 - fresnelNode1 ) * _Innerfresnelintensity ) ) , 0.0 , 1.0 );
			float FresnelMask68 = clampResult170;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float simplePerlin3D153 = snoise( ( ( _Noisespeed * _Time.y ) + ( _Noisescale * ase_vertex3Pos ) ) );
			float temp_output_157_0 = ( ( ( simplePerlin3D153 + _Enablenoise ) * _Enablenoise ) + ( 1.0 - _Enablenoise ) );
			float temp_output_3_0_g1 = ( 1.0 - temp_output_157_0 );
			float Noise160 = ( ( temp_output_157_0 * ( 1.0 - _Sharpennoise ) ) + ( _Sharpennoise * ( 1.0 - saturate( ( temp_output_3_0_g1 / fwidth( temp_output_3_0_g1 ) ) ) ) ) );
			float4 FresnelOut66 = ( FresnelMask68 * _Edgecolor * Noise160 );
			float2 uv_Secondarytexture = i.uv_texcoord * _Secondarytexture_ST.xy + _Secondarytexture_ST.zw;
			float2 panner37 = ( _Time.y * _Secondarypanningspeed + uv_Secondarytexture);
			float3 desaturateInitialColor171 = tex2D( _Secondarytexture, panner37 ).rgb;
			float desaturateDot171 = dot( desaturateInitialColor171, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar171 = lerp( desaturateInitialColor171, desaturateDot171.xxx, 1.0 );
			float4 SecondaryTexOut72 = ( _Secondarytextureintensity * float4( ( ( _Invertsecondarytexture * ( 1.0 - desaturateVar171 ) ) + ( ( 1.0 - _Invertsecondarytexture ) * desaturateVar171 ) ) , 0.0 ) * _Secondarycolor );
			float2 uv_Maintexture = i.uv_texcoord * _Maintexture_ST.xy + _Maintexture_ST.zw;
			float2 panner26 = ( _Time.y * _Mainpanningspeed + uv_Maintexture);
			float3 desaturateInitialColor56 = tex2D( _Maintexture, panner26 ).rgb;
			float desaturateDot56 = dot( desaturateInitialColor56, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar56 = lerp( desaturateInitialColor56, desaturateDot56.xxx, 1.0 );
			float4 MainTexOut64 = ( _Maintextureintensity * float4( ( ( _Invertmaintexture * ( 1.0 - desaturateVar56 ) ) + ( ( 1.0 - _Invertmaintexture ) * desaturateVar56 ) ) , 0.0 ) * _Maincolor );
			float4 EmissionOut70 = ( FresnelOut66 + SecondaryTexOut72 + MainTexOut64 );
			o.Emission = ( _Globalopacity * EmissionOut70 ).rgb;
			o.Alpha = ( _Globalopacity * FresnelMask68 );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction tessphong:_TessPhongStrength 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
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
				vertexDataFunc( v );
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
	CustomEditor "AdultLink.HoloShieldEditor"
}
/*ASEBEGIN
Version=15800
463;73;1114;527;7155.259;3847.614;9.824209;True;False
Node;AmplifyShaderEditor.RangedFloatNode;158;-4119.539,617.2936;Float;False;Property;_Noisescale;Noise scale;34;0;Create;True;0;0;False;0;50;50;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;149;-4099.565,355.6561;Float;False;Property;_Noisespeed;Noise speed;35;0;Create;True;0;0;False;0;0,0,0;0,1,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;147;-4098.759,505.885;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;162;-4117.124,706.1981;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;151;-3903.003,448.3209;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;150;-3911.587,619.3936;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;152;-3742.946,498.8648;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;153;-3622.25,494.0332;Float;False;Simplex3D;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;159;-3696.015,606.4937;Float;False;Property;_Enablenoise;Enable noise;31;1;[Toggle];Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;154;-3422.112,497.9298;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;156;-3304.382,521.4179;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;155;-3366.796,644.7573;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;34;-3978.429,-71.15632;Float;False;Property;_Secondarypanningspeed;Secondary panning speed;19;0;Create;True;0;0;False;0;0,0;0,0.2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;21;-1679.53,727.2562;Float;False;Property;_Bias;Bias;12;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;157;-3156.045,621.5406;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;29;-3922.902,-814.3534;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;36;-3970.952,-190.8348;Float;False;0;32;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;20;-1687.156,815.6852;Float;False;Property;_Scale;Scale;13;0;Create;True;0;0;False;0;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;28;-3952.266,-950.1689;Float;False;Property;_Mainpanningspeed;Main panning speed;3;0;Create;True;0;0;False;0;0,0;0,-1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;19;-1790.329,905.7206;Float;False;Property;_Power;Power;14;0;Create;True;0;0;False;0;2;1.2;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;30;-3949.108,-1080.589;Float;False;0;22;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;176;-3133.809,855.541;Float;False;Constant;_Float1;Float 1;30;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;35;-3876.637,55.41272;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;1;-1484.696,733.6693;Float;True;Standard;TangentNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;37;-3682.148,-110.222;Float;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;26;-3709.486,-969.9785;Float;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;179;-2905.162,754.4102;Float;False;Property;_Sharpennoise;Sharpen noise;32;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;175;-2951.178,840.8917;Float;False;Step Antialiasing;-1;;1;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;178;-2732.41,839.6728;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;32;-3441.621,-139.7896;Float;True;Property;_Secondarytexture;Secondary texture;17;0;Create;True;0;0;False;0;None;693d3cca90d55c741b729cf055d4f0a6;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;166;-1469.375,964.0006;Float;False;Property;_Innerfresnelintensity;Inner fresnel intensity;15;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;22;-3474.303,-966.0268;Float;True;Property;_Maintexture;Main texture;1;0;Create;True;0;0;False;0;None;05e1fe41cc7b13949a096d6310138337;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;184;-2638.893,681.577;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;164;-1189.416,783.5107;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;165;-1492.819,632.6844;Float;False;Property;_Outerfresnelintensity;Outer fresnel intensity;16;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;168;-1184.979,678.6768;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;171;-3151.631,-148.6679;Float;True;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;181;-2419.177,623.7725;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;56;-3183.587,-964.0641;Float;True;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;93;-3169.124,-370.6899;Float;False;Property;_Invertsecondarytexture;Invert secondary texture;20;1;[Toggle];Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-3192.294,-1216.078;Float;False;Property;_Invertmaintexture;Invert main texture;4;1;[Toggle];Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;167;-1033.079,797.2118;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;182;-2428.173,760.9724;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;89;-2892.634,-275.9608;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;25;-2916.086,-1042.074;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;180;-2261.878,683.5726;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;88;-2893.099,-200.3608;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;169;-890.8624,738.3502;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;58;-2915.621,-1117.674;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;86;-1730.805,-1349.593;Float;False;Property;_Extraroughness;Extra roughness;25;0;Create;True;0;0;False;0;0;10;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-1727.108,-965.9724;Float;False;Property;_Distortionspeed;Distortion speed;24;0;Create;True;0;0;False;0;1;0.5;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;87;-1732.941,-1266.987;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;47;-1703.966,-884.0807;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;170;-755.5433,733.1168;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;-2669.217,-314.3289;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;160;-2149.574,680.7734;Float;False;Noise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-2692.204,-1156.042;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;91;-2666.617,-212.9289;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;-2689.604,-1054.642;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;-1395.688,-1169.037;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalVertexDataNode;45;-1731.777,-1118.339;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;108;-1704.318,-531.3018;Float;False;Property;_Pulsephase;Pulse phase;27;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;107;-1704.622,-613.8749;Float;False;Property;_Pulsefrequency;Pulse frequency;28;0;Create;True;0;0;False;0;3;9.79;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-1477.599,-844.7416;Float;False;Property;_Distortionscale;Distortion scale;23;0;Create;True;0;0;False;0;1;2.03;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-1437.476,-955.5549;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;62;-2906.697,-890.3909;Float;False;Property;_Maincolor;Main color;5;1;[HDR];Create;True;0;0;False;0;0.7941176,0.1284602,0.1284602,0.666;1,0.009792074,0,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;92;-2520.168,-273.4628;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;60;-2543.155,-1115.176;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;39;-2678.116,-106.8315;Float;False;Property;_Secondarycolor;Secondary color;21;1;[HDR];Create;True;0;0;False;0;0,0,0,0;1,0.2627451,0.5851504,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;63;-2689.652,-396.5133;Float;False;Property;_Secondarytextureintensity;Secondary texture intensity;18;0;Create;True;0;0;False;0;1;0.75;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-2700.526,-1253.959;Float;False;Property;_Maintextureintensity;Main texture intensity;2;0;Create;True;0;0;False;0;1;0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;68;-603.9926,736.5374;Float;False;FresnelMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;2;-1085.295,937.014;Float;False;Property;_Edgecolor;Edge color;11;1;[HDR];Create;True;0;0;False;0;0.7941176,0.1284602,0.1284602,0.666;1,0,0.009601116,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;76;-1181.952,-840.5203;Float;False;2;0;FLOAT;0;False;1;FLOAT;100;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;112;-1236.546,-557.7244;Float;False;Property;_Pulseamplitude;Pulse amplitude;29;0;Create;True;0;0;False;0;1;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;146;-1192.651,-471.41;Float;False;Constant;_Float0;Float 0;24;0;Create;True;0;0;False;0;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;105;-1446.185,-628.6837;Float;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;50;-1236.88,-1104.373;Float;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;161;-733.3072,1021.291;Float;False;160;Noise;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-2376.921,-1143.139;Float;True;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;145;-1034.651,-554.41;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-2361.993,-279.2797;Float;True;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-539.6148,917.3822;Float;True;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;113;-1028.715,-457.7241;Float;False;Property;_Pulseoffset;Pulse offset;30;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;104;-1249.935,-627.1249;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-969.9874,-887.4515;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;52;-1111.959,-1109.225;Float;True;Simplex3D;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;123;-909.5964,-1248.979;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;72;-2148.714,-284.6128;Float;False;SecondaryTexOut;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;64;-2168.176,-1147.032;Float;False;MainTexOut;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;66;-334.9913,910.881;Float;False;FresnelOut;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;54;-900.5406,-1094.756;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;144;-820.473,-619.8465;Float;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;128;-464.5193,-806.3271;Float;False;Property;_Enablepulsation;Enable pulsation;26;1;[Toggle];Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;122;-710.1879,-1159.912;Float;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;73;-843.2231,15.77335;Float;False;72;SecondaryTexOut;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;99;-511.0839,-651.7536;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;67;-755.6201,-80.22546;Float;False;66;FresnelOut;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;126;-438.4216,-1221.888;Float;False;Property;_Enabledistortion;Enable distortion;22;1;[Toggle];Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;65;-796.8532,120.0106;Float;False;64;MainTexOut;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;129;-123.0278,-669.3439;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;31;-563.2057,-36.32477;Float;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;127;-135.1839,-1178.314;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;70;-363.2369,-39.47409;Float;False;EmissionOut;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;119;51.07063,-952.9338;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;69;-1584.082,105.5971;Float;False;68;FresnelMask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-1651.411,-92.29516;Float;False;Property;_Globalopacity;Global opacity;0;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;199;-1807.439,-2026.136;Float;False;1030.406;372.375;Experimental;7;193;198;195;188;185;194;192;Experimental;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;71;-1582.405,-10.10462;Float;False;70;EmissionOut;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;74;177.059,-957.8647;Float;False;VertexOut;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;198;-1042.033,-1954.307;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;75;-1379.211,200.749;Float;False;74;VertexOut;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-1350.538,89.70304;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;188;-1216.156,-1906.151;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;193;-1614.459,-1975.432;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;195;-1408.777,-1891.341;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-1328.935,-87.18736;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;194;-1757.439,-1976.136;Float;False;Constant;_Float2;Float 2;32;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;185;-1336.087,-1768.761;Float;False;Property;_Sharpennn;Sharpennn;33;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;192;-1551.883,-1867.589;Float;False;Constant;_Float3;Float 3;30;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-1136.432,-150.5388;Float;False;True;6;Float;AdultLink.HoloShieldEditor;0;0;Standard;AdultLink/HoloShield;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;0;1;10;25;True;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;6;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.CommentaryNode;124;-1736.584,-704.8448;Float;False;1437.686;328.0779;Pulsation;0;;0.990566,0.9615986,0.2663314,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;125;-1747.549,-1402.168;Float;False;1259.065;659.0585;Distortion;0;;1,0.3975925,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;163;-4167.124,305.6562;Float;False;2246.313;660.4777;Noise;0;Noise;0.7782524,0.5607843,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;80;-1781.556,-1521.595;Float;False;2186.53;1179.224;Vertex manipulation;0;Vertex manipulation;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;78;-4004.953,-457.0949;Float;False;2100.483;666.5062;Secondary texture;0;Secondary texture;0.4411765,1,0.5837727,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;77;-4002.266,-1303.958;Float;False;2077.09;620.5684;Main texture;0;Main texture;1,0.8264706,0.5661765,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;79;-1848.052,567.7039;Float;False;1761.348;598.0276;Fresnel;0;Fresnel;0.4632353,0.7334687,1,1;0;0
WireConnection;151;0;149;0
WireConnection;151;1;147;0
WireConnection;150;0;158;0
WireConnection;150;1;162;0
WireConnection;152;0;151;0
WireConnection;152;1;150;0
WireConnection;153;0;152;0
WireConnection;154;0;153;0
WireConnection;154;1;159;0
WireConnection;156;0;154;0
WireConnection;156;1;159;0
WireConnection;155;0;159;0
WireConnection;157;0;156;0
WireConnection;157;1;155;0
WireConnection;1;1;21;0
WireConnection;1;2;20;0
WireConnection;1;3;19;0
WireConnection;37;0;36;0
WireConnection;37;2;34;0
WireConnection;37;1;35;0
WireConnection;26;0;30;0
WireConnection;26;2;28;0
WireConnection;26;1;29;0
WireConnection;175;1;157;0
WireConnection;175;2;176;0
WireConnection;178;0;175;0
WireConnection;32;1;37;0
WireConnection;22;1;26;0
WireConnection;184;0;179;0
WireConnection;164;0;1;0
WireConnection;168;0;165;0
WireConnection;168;1;1;0
WireConnection;171;0;32;0
WireConnection;181;0;157;0
WireConnection;181;1;184;0
WireConnection;56;0;22;0
WireConnection;167;0;164;0
WireConnection;167;1;166;0
WireConnection;182;0;179;0
WireConnection;182;1;178;0
WireConnection;89;0;93;0
WireConnection;25;0;56;0
WireConnection;180;0;181;0
WireConnection;180;1;182;0
WireConnection;88;0;171;0
WireConnection;169;0;168;0
WireConnection;169;1;167;0
WireConnection;58;0;57;0
WireConnection;170;0;169;0
WireConnection;90;0;93;0
WireConnection;90;1;88;0
WireConnection;160;0;180;0
WireConnection;59;0;57;0
WireConnection;59;1;25;0
WireConnection;91;0;89;0
WireConnection;91;1;171;0
WireConnection;61;0;58;0
WireConnection;61;1;56;0
WireConnection;84;0;86;0
WireConnection;84;1;87;0
WireConnection;49;0;48;0
WireConnection;49;1;47;0
WireConnection;92;0;90;0
WireConnection;92;1;91;0
WireConnection;60;0;59;0
WireConnection;60;1;61;0
WireConnection;68;0;170;0
WireConnection;76;0;53;0
WireConnection;105;0;47;0
WireConnection;105;1;107;0
WireConnection;105;2;108;0
WireConnection;50;0;84;0
WireConnection;50;1;45;0
WireConnection;50;2;49;0
WireConnection;24;0;40;0
WireConnection;24;1;60;0
WireConnection;24;2;62;0
WireConnection;145;0;112;0
WireConnection;145;1;146;0
WireConnection;38;0;63;0
WireConnection;38;1;92;0
WireConnection;38;2;39;0
WireConnection;3;0;68;0
WireConnection;3;1;2;0
WireConnection;3;2;161;0
WireConnection;104;0;105;0
WireConnection;55;0;76;0
WireConnection;52;0;50;0
WireConnection;72;0;38;0
WireConnection;64;0;24;0
WireConnection;66;0;3;0
WireConnection;54;0;52;0
WireConnection;54;3;55;0
WireConnection;54;4;76;0
WireConnection;144;0;104;0
WireConnection;144;1;145;0
WireConnection;144;2;113;0
WireConnection;122;0;123;0
WireConnection;122;1;54;0
WireConnection;99;0;45;0
WireConnection;99;1;144;0
WireConnection;129;0;128;0
WireConnection;129;1;99;0
WireConnection;31;0;67;0
WireConnection;31;1;73;0
WireConnection;31;2;65;0
WireConnection;127;0;126;0
WireConnection;127;1;122;0
WireConnection;70;0;31;0
WireConnection;119;0;127;0
WireConnection;119;1;129;0
WireConnection;74;0;119;0
WireConnection;198;0;193;0
WireConnection;198;1;188;0
WireConnection;198;2;185;0
WireConnection;44;0;41;0
WireConnection;44;1;69;0
WireConnection;188;0;195;0
WireConnection;193;0;194;0
WireConnection;193;1;52;0
WireConnection;195;0;193;0
WireConnection;195;1;192;0
WireConnection;42;0;41;0
WireConnection;42;1;71;0
WireConnection;0;2;42;0
WireConnection;0;9;44;0
WireConnection;0;11;75;0
ASEEND*/
//CHKSM=E301DDABF0AFEECAD59D41D6D723B4F82A34412B