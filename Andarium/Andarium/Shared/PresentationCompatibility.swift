// SPDX-License-Identifier: GPL-2.0-or-later

import SwiftUI

struct PanelGroup<Content: View>: View {
    let spacing: CGFloat
    @ViewBuilder var content: () -> Content

    var body: some View {
        if #available(iOS 26.0, *) {
            GlassEffectContainer(spacing: spacing, content: content)
        } else {
            content()
        }
    }
}

extension View {
    @ViewBuilder
    func panelSurface<S: Shape>(tint: Color? = nil, interactive: Bool = false, in shape: S) -> some View {
        if #available(iOS 26.0, *) {
            glassEffect(.regular.tint(tint).interactive(interactive), in: shape)
        } else {
            background { shape.fill(.regularMaterial).overlay { shape.fill(tint ?? .clear) } }
        }
    }

    @ViewBuilder
    func panelButton(prominent: Bool = false) -> some View {
        if #available(iOS 26.0, *) {
            if prominent { buttonStyle(.glassProminent) } else { buttonStyle(.glass) }
        } else {
            if prominent { buttonStyle(.borderedProminent) } else { buttonStyle(.bordered) }
        }
    }

    @ViewBuilder
    func bottomBar<Bar: View>(@ViewBuilder content: () -> Bar) -> some View {
        if #available(iOS 26.0, *) {
            safeAreaBar(edge: .bottom, content: content)
        } else {
            safeAreaInset(edge: .bottom, spacing: 0, content: content)
        }
    }

    @ViewBuilder
    func windowCornerOffset(_ edges: Edge.Set, sizeToFit: Bool) -> some View {
        if #available(iOS 26.0, *) {
            containerCornerOffset(edges, sizeToFit: sizeToFit)
        } else {
            self
        }
    }

    @ViewBuilder
    func zoomSource(id: String, in namespace: Namespace.ID) -> some View {
        if #available(iOS 18.0, *) {
            matchedTransitionSource(id: id, in: namespace)
        } else {
            self
        }
    }

    @ViewBuilder
    func fixedSheetSize(width: CGFloat, height: CGFloat) -> some View {
        if #available(iOS 18.0, *) {
            presentationSizing(FixedSheetSizing(width: width, height: height))
        } else {
            self
        }
    }

    @ViewBuilder
    func sheetSubtitle(_ subtitle: String) -> some View {
        if #available(iOS 26.0, *) {
            navigationSubtitle(subtitle)
        } else if !subtitle.isEmpty {
            safeAreaInset(edge: .top, spacing: 0) {
                Text(verbatim: subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 4)
                    .frame(maxWidth: .infinity)
                    .background(.bar)
            }
        } else {
            self
        }
    }

    @ViewBuilder
    func sheetSize(form: Bool) -> some View {
        if #available(iOS 18.0, *) {
            if form { presentationSizing(.form) } else { presentationSizing(.page) }
        } else {
            self
        }
    }
}
