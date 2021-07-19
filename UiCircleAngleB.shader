//x軸から円に
Shader "UiCercles/UiCercleAngleB"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Color ("Color", Color) = (1, 1, 1, 1)
		_Emission ("Emission", float) = 2
		_Diameter ("Diameter半径", float) = 0.5
		_IDiameter ("InnerDiameter内径", float) = 0.45
		_Angle ("Angle", float) = 0
		_AngleEnd ("AngleEnd", float) = 0
    }
    SubShader
    {
        Tags {
			"Queue"="Transparent"
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
			#define PULSE(a, b, x) (step(a, x) - step(b, x))

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
			float _Angle;
			float _AngleEnd;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				float2 pos = i.uv * 2.0 - float2(1.0, 1.0);
                fixed4 col = tex2D(_MainTex, i.uv) * _Color * _Emission;
				float r = distance(pos, float2(0.0, 0.0));
				col.a = step(r, _Diameter) * step(_IDiameter, r) * _Color.a * step( asin(pos.y / r), _Angle) * step(_AngleEnd ,asin(pos.y / r));
                return col;
            }
            ENDCG
        }
    }
}
