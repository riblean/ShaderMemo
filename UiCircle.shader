//初めてのシェーダー！！2019/03/19
//円形の線（サークル）を描く。Shader "Custom/NewUnlitShader"
Shader "Custom/UiCercle"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Color ("Color", Color) = (1, 1, 1, 1)
		_Emission ("Emission", float) = 2
		_SecondAlpha ("SecondAlpha", float) = 1
		_Radium ("Radium", float) = 0.4
		_Thickness ("thickness", float) = 0.05
		_ThickBar ("thicknessBar", float) = 0.1
		_ThickCurrent ("thicknessCurretn", float) = 0.05
		_HPBar ("HitPointBar", float) = 1
		_HPCBar ("HitPointCurrentBar", float) = 1
		_BoostBar ("BoostBar", float) = 1
		_BoostCBar ("BoostCurrentBar", float) = 1
		_test ("test", float) = 0.5
		_test2 ("test2", float) = 0.5
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
			fixed _SecondAlpha;
			float _Radium;
			float _Thickness;
			float _ThickBar;
			float _ThickCurrent;
			float _HPBar;
			float _HPCBar;
			float _BoostBar;
			float _BoostCBar;
			float _test;
			float _test2;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
			/*
				fixed a = 0.141471;
				fixed r = distance(i.uv, fixed2(0.5, 0.5));
				fixed b = step(0.7 + a * (1 - _BoostBar), sin((i.uv.x - 0.5) / r)) + step(sin((i.uv.x - 0.5) / r), -0.7 - a * (1 - _BoostBar));//8.45-7
				b += step(0.6 + (a + 0.1) * (1 - _HPBar), sin((i.uv.y - 0.5) / r)) + step(sin((i.uv.y - 0.5) / r), -0.6 -(a + 0.1) * (1 - _HPBar));//8.45-6
				b *= step(r, 0.5) * step(0.5 - _ThickBar ,r);
				fixed bc = step(0.7 + a * (1 - _BoostCBar), sin((i.uv.x - 0.5) / r)) + step(sin((i.uv.x - 0.5) / r), -0.7 - a * (1 - _BoostCBar));
				bc += step(0.6 + (a + 0.1) * (1 - _HPCBar), sin((i.uv.y - 0.5) / r)) + step(sin((i.uv.y - 0.5) / r), -0.6 - (a + 0.1) * (1 - _HPCBar));//8.45-7
				bc *= step(r, 0.5 - _ThickBar - _Thickness - 0.02 ) * step(0.5 - _ThickBar - _Thickness - 0.02 - _ThickCurrent ,r);
				b += step(r, _Radium) * step(0.5 - _ThickBar - _Thickness - 0.01 ,r) + bc;
                fixed4 col = _Color * _Emission;
				col.a = _Color.a * clamp(b, 0, 1) / _EmissionAlpha;
                return col;
				*/
				fixed a = 0;
				fixed r = distance(i.uv, fixed2(0.5, 0.5));
				a += (step(0.6 + (a + 0.1) * (1 - _HPBar), sin((i.uv.y - 0.5) / r)) + step(sin((i.uv.y - 0.5) / r), -0.6 -(a + 0.1) * (1 - _HPBar))) * step(r, 0.5) * step(0.5 - _ThickBar ,r);
				a += step(r, _Radium + _Thickness) * step(_Radium,r) * _SecondAlpha;
				fixed4 col = _Color * _Emission;
				col.a = _Color.a * a;
				return col;
            }
            ENDCG
        }
    }
}