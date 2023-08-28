#-- copyright
# OpenProject is an open source project management software.
# Copyright (C) 2012-2023 the OpenProject GmbH
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2013 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See COPYRIGHT and LICENSE files for more details.
#++

require 'spec_helper'

RSpec.describe OpenProject::AccessControl::Permission do
  describe '#dependencies' do
    context 'for a permission with a dependency' do
      subject { OpenProject::AccessControl.permission(:edit_work_packages) }

      it 'denotes the pre-requisites' do
        expect(subject.dependencies)
          .to contain_exactly(:view_work_packages)
      end
    end

    context 'for a permission without a dependency' do
      subject { OpenProject::AccessControl.permission(:view_work_packages) }

      it 'is empty' do
        expect(subject.dependencies)
          .to be_empty
      end
    end
  end

  describe '#global?' do
    context 'when it is marked as global' do
      subject(:permission) do
        described_class.new(:perm, { cont: [:action] }, global: true)
      end

      it { expect(permission).to be_global }
    end

    context 'when it is marked as non-global' do
      subject(:permission) do
        described_class.new :perm, { cont: [:action] }, global: false
      end

      it { expect(permission).not_to be_global }
    end

    describe "without specifying whether the permission is global or not" do
      subject(:permission) do
        described_class.new :perm, { cont: [:action] }
      end

      it 'defaults to non-global' do
        expect(permission).not_to be_global
      end
    end
  end

  describe '#grant_to_admin?' do
    context 'when it is marked as grant-able to admin' do
      subject(:permission) do
        described_class.new(:perm, {}, grant_to_admin: true)
      end

      it { expect(permission).to be_grant_to_admin }
    end

    context 'when it is marked as non-grant-able to admin' do
      subject(:permission) do
        described_class.new(:perm, {}, grant_to_admin: false)
      end

      it { expect(permission).not_to be_grant_to_admin }
    end

    context 'without specifying whether the permissions is grant-able to admin or not' do
      subject(:permission) do
        described_class.new(:perm, {})
      end

      it 'defaults to grant-able to admin' do
        expect(permission).to be_grant_to_admin
      end
    end
  end
end
