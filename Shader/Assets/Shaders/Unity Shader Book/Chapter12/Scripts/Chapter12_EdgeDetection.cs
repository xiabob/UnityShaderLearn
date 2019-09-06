using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Chapter12_EdgeDetection : PostEffectBase
{

    [SerializeField] private Shader m_Shader;
    [SerializeField] private Color m_EdgeColor = Color.black;
    [SerializeField] private Color m_Background = Color.white;
    [SerializeField] private bool m_EdgeOnly = false;

    private Material m_ShaderMaterial;
    public Material ShaderMaterial
    {
        get
        {
            m_ShaderMaterial = CreateMaterialByShader(m_Shader, m_ShaderMaterial);
            return m_ShaderMaterial;
        }
    }

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (ShaderMaterial != null)
        {
            ShaderMaterial.SetColor("_EdgeColor", m_EdgeColor);
            ShaderMaterial.SetColor("_BackgroundColor", m_Background);
            ShaderMaterial.SetFloat("_EdgeOnly", m_EdgeOnly ? 1 : 0);
            Graphics.Blit(src, dest, ShaderMaterial);
        }
        else
        {
            Graphics.Blit(src, dest);
        }
    }

}
