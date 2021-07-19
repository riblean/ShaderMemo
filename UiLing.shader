//基本・輪っか
Shader "UiCercles/UiLing"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Color ("Color", Color) = (1, 1, 1, 1)
		_Emission ("Emission", float) = 2
		_Diameter ("Diameter半径", float) = 0.5
		_IDiameter ("InnerDiameter内径", float) = 0.45

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
			fixed _Emission;
			float _Diameter;
			float _IDiameter;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv) * _Color * _Emission;
				float r = distance(i.uv, float2(0.5, 0.5));
				fixed a = step(r, _Diameter) * step(_IDiameter, r) * _Color.a;
				col.a = a;
                return col;
            }
            ENDCG
        }
    }
}
