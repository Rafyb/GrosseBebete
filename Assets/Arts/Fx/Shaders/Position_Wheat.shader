// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "VFX/Environment/Position_Weat"
{
	Properties
	{
		[HideInInspector] _VTInfoBlock( "VT( auto )", Vector ) = ( 0, 0, 0, 0 )
		_Power("Power", Range( 0 , 6)) = 0
		_Mask("Mask", Range( -10 , 1)) = 1
		_ColorWheat("Color Wheat", Color) = (0,0,0,0)
		_UVTiling("UV Tiling", Vector) = (1,1,0,0)
		_UVOffset("UV Offset", Vector) = (1,1,0,0)
		_MainText("MainText", 2D) = "white" {}
		_FrequenceY("Frequence Y", Float) = 0
		_AmplificationY("Amplification Y", Float) = 0
		_FrequenceX("Frequence X", Float) = 0
		_AmplificationX("Amplification X", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "Amplify" = "True"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		AlphaToMask On
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _FrequenceY;
		uniform float _AmplificationY;
		uniform float _FrequenceX;
		uniform float _AmplificationX;
		uniform float4 _ColorWheat;
		uniform sampler2D _MainText;
		uniform float2 _UVTiling;
		uniform float2 _UVOffset;
		uniform float _Mask;
		uniform float _Power;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 VertexPosition71 = ase_vertex3Pos;
			float3 break67 = ase_vertex3Pos;
			float AxisX69 = break67.x;
			float AxisY68 = break67.y;
			float AxisZ70 = break67.z;
			float3 appendResult58 = (float3(AxisX69 , ( AxisY68 + ( sin( ( ( AxisX69 * _FrequenceY ) + _Time.y ) ) * _AmplificationY ) ) , AxisZ70));
			float3 lerpResult62 = lerp( VertexPosition71 , appendResult58 , v.texcoord.xy.y);
			float3 appendResult61 = (float3(( AxisX69 + ( sin( ( ( AxisY68 * _FrequenceX ) + _Time.y ) ) * _AmplificationX ) ) , AxisY68 , AxisZ70));
			float3 lerpResult63 = lerp( VertexPosition71 , appendResult61 , v.texcoord.xy.x);
			float3 lerpResult65 = lerp( lerpResult62 , lerpResult63 , VertexPosition71);
			v.vertex.xyz = lerpResult65;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 tex2DNode20 = tex2D( _MainText, (i.uv_texcoord*_UVTiling + _UVOffset) );
			o.Albedo = ( _ColorWheat * tex2DNode20 ).rgb;
			o.Alpha = saturate( ( tex2DNode20 * pow( ( ( 1.0 - i.uv_texcoord.y ) - _Mask ) , _Power ) ) );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			AlphaToMask Off
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
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
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
Version=18500
85.6;369.6;611;392;-524.5339;-1063.131;1.621775;True;False
Node;AmplifyShaderEditor.CommentaryNode;36;-2129.243,1369.07;Inherit;False;944.2668;557.4694;Comment;6;71;70;69;68;67;66;Vertex Position;1,1,1,1;0;0
Node;AmplifyShaderEditor.PosVertexDataNode;66;-2079.243,1733.604;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;67;-1791.106,1517.738;Inherit;True;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RegisterLocalVarNode;69;-1440.042,1419.07;Inherit;False;AxisX;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;68;-1426.882,1501.389;Inherit;False;AxisY;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;37;-918.5231,1363.382;Inherit;False;3065.414;1329.32;Comment;28;65;64;63;62;61;60;59;58;57;56;55;54;53;52;51;50;49;48;47;46;45;44;43;42;41;40;39;38;Movement Grass Axis X & Y;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;40;-609.5543,2123.215;Inherit;False;68;AxisY;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-758.8041,2264.082;Inherit;False;Property;_FrequenceX;Frequence X;9;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;41;-676.9933,1561.179;Inherit;False;69;AxisX;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-868.5231,1714.697;Inherit;False;Property;_FrequenceY;Frequence Y;7;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-482.1022,1579.298;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-372.3412,2162.993;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;43;-457.9181,1889.993;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;46;-197.7942,1681.662;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;45;-88.07523,2231.047;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;48;165.2267,2493.125;Inherit;False;Property;_AmplificationX;Amplification X;10;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;49;209.3287,2188.289;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;64.85478,1932.06;Inherit;False;Property;_AmplificationY;Amplification Y;8;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;11;-587.0092,926.2551;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinOpNode;47;161.9457,1689.392;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;549.832,2337.535;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;70;-1409.777,1594.246;Inherit;False;AxisZ;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;25;-432.2828,739.2339;Inherit;False;Property;_UVOffset;UV Offset;5;0;Create;True;0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;53;418.6867,1553.214;Inherit;False;68;AxisY;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-344.062,1157.973;Inherit;False;Property;_Mask;Mask;2;0;Create;True;0;0;False;0;False;1;-0.8;-10;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;504.2665,1919.477;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;52;569.2811,2162.663;Inherit;False;69;AxisX;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;24;-341.2975,600.719;Inherit;False;Property;_UVTiling;UV Tiling;4;0;Create;True;0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.OneMinusNode;34;-269.9977,990.1702;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VirtualTextureObject;35;-185.9465,429.4175;Inherit;True;Property;_MainText;MainText;6;0;Create;True;0;0;False;0;False;-1;None;None;False;white;Auto;Unity5;0;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;26;389.2326,1119.628;Inherit;False;Property;_Power;Power;1;0;Create;True;0;0;False;0;False;0;0;0;6;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;15;74.15207,1019.976;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;57;762.2726,1456.315;Inherit;False;70;AxisZ;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;71;-1749.13,1811.14;Inherit;False;VertexPosition;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;56;848.0011,2139.546;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;55;680.3907,1584.372;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;23;-124.0184,671.3344;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;58;1043.153,1506.763;Inherit;True;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;59;1274.146,1618.322;Inherit;False;71;VertexPosition;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PowerNode;27;739.662,953.7958;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;20;167.9487,709.3571;Inherit;True;Property;_Texture;Texture;4;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;60;1091.473,1809.856;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;61;1115.315,1978.989;Inherit;True;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;63;1562.029,1963.288;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;64;1549.163,1855.661;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;1052.568,803.3762;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;19;220.9166,501.4444;Inherit;False;Property;_ColorWheat;Color Wheat;3;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;62;1546.622,1668.202;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;30;1243.27,806.91;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;65;1775.604,1810.668;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;561.765,629.2358;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2493.851,1209.655;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;VFX/Environment/Position_Weat;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Absolute;0;;0;-1;-1;-1;0;True;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;67;0;66;0
WireConnection;69;0;67;0
WireConnection;68;0;67;1
WireConnection;42;0;41;0
WireConnection;42;1;39;0
WireConnection;44;0;40;0
WireConnection;44;1;38;0
WireConnection;46;0;42;0
WireConnection;46;1;43;0
WireConnection;45;0;44;0
WireConnection;45;1;43;0
WireConnection;49;0;45;0
WireConnection;47;0;46;0
WireConnection;54;0;49;0
WireConnection;54;1;48;0
WireConnection;70;0;67;2
WireConnection;51;0;47;0
WireConnection;51;1;50;0
WireConnection;34;0;11;2
WireConnection;15;0;34;0
WireConnection;15;1;16;0
WireConnection;71;0;66;0
WireConnection;56;0;52;0
WireConnection;56;1;54;0
WireConnection;55;0;53;0
WireConnection;55;1;51;0
WireConnection;23;0;11;0
WireConnection;23;1;24;0
WireConnection;23;2;25;0
WireConnection;58;0;52;0
WireConnection;58;1;55;0
WireConnection;58;2;57;0
WireConnection;27;0;15;0
WireConnection;27;1;26;0
WireConnection;20;0;35;0
WireConnection;20;1;23;0
WireConnection;61;0;56;0
WireConnection;61;1;53;0
WireConnection;61;2;57;0
WireConnection;63;0;59;0
WireConnection;63;1;61;0
WireConnection;63;2;60;1
WireConnection;64;0;59;0
WireConnection;22;0;20;4
WireConnection;22;1;27;0
WireConnection;62;0;59;0
WireConnection;62;1;58;0
WireConnection;62;2;60;2
WireConnection;30;0;22;0
WireConnection;65;0;62;0
WireConnection;65;1;63;0
WireConnection;65;2;64;0
WireConnection;21;0;19;0
WireConnection;21;1;20;0
WireConnection;0;0;21;0
WireConnection;0;9;30;0
WireConnection;0;11;65;0
ASEEND*/
//CHKSM=997C2B1FB0361168CD38F0B9986C2493E262360A