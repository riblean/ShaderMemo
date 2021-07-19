﻿//初めてのシェーダー！！2019/03/19
//円形の線（サークル）を描く。Shader "Custom/NewUnlitShader"
Shader "Custom/test"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Color ("Color", Color) = (1, 1, 1, 1)
		_Radium ("Radium", float) = 0.5
		_Inner ("Inner Diameter", float) = 0.3
    }
    SubShader
    {
        Tags {
			"RenderType"="Transparent"
			"IgnoreProjector"="True"
			"RenderType"="Transparent"
		}
        LOD 100

		ZWrite off
		Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
			fixed4 _Color;
			float _Radium;
			float _Inner;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				fixed r = distance(i.uv, fixed2(0.5, 0.5));
                fixed4 col = tex2D(_MainTex, i.uv) * _Color;
				col.a *= step(r, _Radium) * step(_Inner ,r);
                return col;
            }
            ENDCG
        }
    }
}